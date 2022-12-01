# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  first_name    :string
#  last_name     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  login_digest  :string
#  login_sent_at :datetime
#
class User < ApplicationRecord
  attr_accessor :login_token

  has_secure_password :login

  before_create :atmost_one_user

  # Passwords
  # =========

  # Returns a random token
  # String of 22 characters.
  # User.new_token
  #   => "ZKZOh2N7iPPGHXSPx5incQ"
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns the hash digest of a string
  # User.digest("ZKZOh2N7iPPGHXSPx5incQ")
  #   => "$2a$12$hd3Ey3gEjEXGpMiKeqmQYOd9oXeL2kiYGZbBZx8qeb0Y0PBJmkMGa"
  # This hash digest is stored in the database
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  private

  # Allow only one user to exist.
  def atmost_one_user
    throw :abort if User.count == 1
  end
end
