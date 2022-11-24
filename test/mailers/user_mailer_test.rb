require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_login" do
    mail = UserMailer.account_login
    assert_equal "Account login", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
