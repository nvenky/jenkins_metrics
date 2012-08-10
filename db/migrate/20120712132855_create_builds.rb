class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :build_number
      t.integer :total_test
      t.integer :skipped_test

      t.timestamps
    end
  end
end
