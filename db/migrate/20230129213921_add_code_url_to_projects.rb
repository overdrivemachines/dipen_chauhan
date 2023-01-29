class AddCodeUrlToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :code_url, :string
    rename_column :projects, :url, :live_url
  end
end
