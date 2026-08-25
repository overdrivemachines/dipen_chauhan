# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  first_name    :string
#  last_name     :string
#  login_digest  :string
#  login_sent_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "strips whitespace from profile attributes" do
    user = User.new(
      email: "  dipen@example.com  ",
      first_name: "  Dipen  ",
      last_name: "  Chauhan  ",
      login: "password",
      login_confirmation: "password"
    )

    user.valid?

    assert_equal "dipen@example.com", user.email
    assert_equal "Dipen", user.first_name
    assert_equal "Chauhan", user.last_name
  end
end
