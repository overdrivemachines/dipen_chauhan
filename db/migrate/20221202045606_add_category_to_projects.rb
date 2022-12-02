class AddCategoryToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :category, null: false, foreign_key: true
  end
end
