class Build < ActiveRecord::Base
  attr_accessible :build_number, :skipped_test, :total_test, :authors, :project, :change_sets, :total_changes, :java_changes, :test_changes
  belongs_to :project
  has_many :change_sets	
  has_many :authors
end
