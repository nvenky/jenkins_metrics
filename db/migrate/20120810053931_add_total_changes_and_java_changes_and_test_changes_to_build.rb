class AddTotalChangesAndJavaChangesAndTestChangesToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :total_changes, :integer
    add_column :builds, :java_changes, :integer
    add_column :builds, :test_changes, :integer
  end
end
