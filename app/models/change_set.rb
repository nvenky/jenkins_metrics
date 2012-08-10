class ChangeSet < ActiveRecord::Base
  belongs_to :build
  attr_accessible :change_type, :file_name, :build
end
