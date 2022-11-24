class AddRememberDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :remember_digest, :string

    # when user wants to log in, login_digest is set.
    add_column :users, :login_digest, :string
    add_column :users, :login_sent_at, :string

    # Password digest not needed for passwordless login
    remove_column :users, :password_digest
  end
end
