class CreateChangeSets < ActiveRecord::Migration
  def change
    create_table :change_sets do |t|
      t.string :file_name
      t.string :change_type
      t.references :build

      t.timestamps
    end
    add_index :change_sets, :build_id
  end
end
