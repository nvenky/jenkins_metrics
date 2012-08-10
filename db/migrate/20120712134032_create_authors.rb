class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.references :build

      t.timestamps
    end
    add_index :authors, :build_id
  end
end
