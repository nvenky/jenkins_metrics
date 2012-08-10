class Author < ActiveRecord::Base
  belongs_to :build
  attr_accessible :name
end
