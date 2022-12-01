class RemoveColsFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :remember_digest, :string
    remove_column :users, :login_sent_at, :string
    remove_column :users, :reset_sent_at, :datetime

    add_column :users, :login_sent_at, :datetime
  end
end
