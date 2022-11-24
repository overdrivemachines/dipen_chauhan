# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  first_name      :string
#  last_name       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_digest :string
#  login_digest    :string
#  login_sent_at   :string
#
class User < ApplicationRecord
  has_secure_password

  before_create :atmost_one_user

  # Allow only one user to exist.
  def atmost_one_user
    throw :abort if User.size == 1
  end

  # Login
  # =====

  # Send an email containing the login link
  def send_login_email; end

  # Passwords
  # =========

  # Returns a random token
  # String of 22 characters
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns the hash digest of a string
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end
end
