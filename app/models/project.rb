class Project < ActiveRecord::Base
  attr_accessible :name, :url, :builds
  has_many :builds
end
