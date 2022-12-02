class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :abbr

      t.timestamps
    end

    add_index :categories, :abbr, unique: true
  end
end
