class ChangeSetsController < ApplicationController
  # GET /change_sets
  # GET /change_sets.json
  def index
    @change_sets = ChangeSet.find_all_by_build_id(params[:id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @change_sets }
    end
  end

  # GET /change_sets/1
  # GET /change_sets/1.json
  def show
    @change_set = ChangeSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @change_set }
    end
  end

  # GET /change_sets/new
  # GET /change_sets/new.json
  def new
    @change_set = ChangeSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @change_set }
    end
  end

  # GET /change_sets/1/edit
  def edit
    @change_set = ChangeSet.find(params[:id])
  end

  # POST /change_sets
  # POST /change_sets.json
  def create
    @change_set = ChangeSet.new(params[:change_set])

    respond_to do |format|
      if @change_set.save
        format.html { redirect_to @change_set, notice: 'Change set was successfully created.' }
        format.json { render json: @change_set, status: :created, location: @change_set }
      else
        format.html { render action: "new" }
        format.json { render json: @change_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /change_sets/1
  # PUT /change_sets/1.json
  def update
    @change_set = ChangeSet.find(params[:id])

    respond_to do |format|
      if @change_set.update_attributes(params[:change_set])
        format.html { redirect_to @change_set, notice: 'Change set was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @change_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /change_sets/1
  # DELETE /change_sets/1.json
  def destroy
    @change_set = ChangeSet.find(params[:id])
    @change_set.destroy

    respond_to do |format|
      format.html { redirect_to change_sets_url }
      format.json { head :no_content }
    end
  end
end
