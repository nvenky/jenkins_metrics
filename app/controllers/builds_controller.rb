require 'uri'
require 'open-uri'
require 'json'

class BuildsController < ApplicationController
  
  def index
    @builds = Build.find_all_by_project_id(params[:project_id], :order => 'build_number desc')
    @project_name = Project.find(params[:project_id]).name
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @builds }
    end
  end

  def show
    @build = Build.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @build }
    end
  end

  def new
    @build = Build.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @build }
    end
  end

  def edit
    @build = Build.find(params[:id])
  end

  def create
    @build = Build.new(params[:build])
    respond_to do |format|
      if @build.save
        format.html { redirect_to @build, notice: 'Build was successfully created.' }
        format.json { render json: @build, status: :created, location: @build }
      else
        format.html { render action: "new" }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /builds/1
  # PUT /builds/1.json
  def update
    @build = Build.find(params[:id])

    respond_to do |format|
      if @build.update_attributes(params[:build])
        format.html { redirect_to @build, notice: 'Build was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @build.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /builds/1
  # DELETE /builds/1.json
  def destroy
    @build = Build.find(params[:id])
    @build.destroy

    respond_to do |format|
      format.html { redirect_to builds_url }
      format.json { head :no_content }
    end
  end



  def load_latest_builds     
     load_builds(params[:project_id])    
     redirect_to :action => :index
  end

  def load_builds(project_id)
     project = Project.find(project_id)
     url = project.url.strip     
     json = load_json("#{url}/api/json")
     
     json['builds'].reverse.each do |build| 
	build_num =build['number']
	if (Build.find_by_project_id_and_build_number(project_id, build_num).nil?)
          test_data_json = load_json("#{url}/#{build_num}/api/json")
	  if test_data_json['result'] == 'SUCCESS'	  	 
	     load_new_build test_data_json, build_num, project
	  end
	end
     end     
  end

  def update_build_date_to_existing_builds
     projects = Project.all
     projects.each do |project|
	     url = project.url.strip     
	     json = load_json("#{url}/api/json")
	     json['builds'].reverse.each do |json_build| 
		build_num = json_build['number']
		build = Build.find_by_project_id_and_build_number(project.id, build_num) 
		if (!build.nil?)
	          build_json = load_json("#{url}/#{build_num}/api/json")
		  build.build_date = build_time build_json
		  build.save!
		end
	     end
     end
  end

  def update_change_set_to_existing_builds
     projects = Project.all
     projects.each do |project|
	     url = project.url.strip     
	     json = load_json("#{url}/api/json")
	     json['builds'].reverse.each do |json_build| 
		build_num = json_build['number']
		build = Build.find_by_project_id_and_build_number(project.id, build_num) 
		if (!build.nil?)
	          build_json = load_json("#{url}/#{build_num}/api/json")
		  load_change_sets build_json, build
		end
	     end
     end
  end

  def update_changes_count_to_existing_builds
    Build.all.each do |build|
	update_change_set_metrics build	
	build.save!
    end	    
  end

  private

  def load_new_build(json, build_num, project)
    authors = load_authors_from_json json
    if !authors.empty?
       	test_result = test_result json['actions']
	new_build = Build.create(:build_number => build_num, :total_test => test_result['totalCount'],
			  :skipped_test => test_result['skipCount'], :authors => authors, :project => project)
	new_build.build_date = build_time json
	load_change_sets json, new_build
	update_change_set_metrics new_build
	new_build.save!
    end
  end

  def update_change_set_metrics(build)
	build.total_changes = build.change_sets.count
        build.test_changes = build.change_sets.select{|cs| cs.file_name.include?('Test.java')}.count	
        build.java_changes = build.change_sets.select{|cs| cs.file_name.include?('.java')}.count - build.test_changes	
  end

  def load_change_sets(json, build)
	changes= json['changeSet']['items'][0]
	['addedPaths', 'deletedPaths', 'modifiedPaths'].each do |change_type|
          changes[change_type].each do |changed_item|	     
	   change_set = ChangeSet.new(:file_name => changed_item, :change_type => change_type, :build => build)
	   change_set.save!
	  end
	end
  end

  def test_result(actions)
     actions.each {|action| return action if !action['totalCount'].nil?}
  end

  def load_authors_from_json(json)
     author_names = []
     json['changeSet']['items'].each do |item| 
	     author_names.push(item['author']['fullName']) 
     end
     authors =[]
     author_names.uniq.each do |author_name| 
	     authors.push Author.new(:name => author_name)
     end
     authors
  end

  def build_time(json)
    build_time = json['timestamp']/1000
    DateTime.strptime(build_time.to_s,'%s')
  end

  def load_health(json)
     json['healthReport'][0]['description'].scan(/\d+/)     
  end

  def load_json(url)
     JSON.parse(open(URI.escape(url)).read)
  end

end
