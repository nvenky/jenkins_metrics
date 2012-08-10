class AddBuildDateToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :build_date, :datetime
  end
end
