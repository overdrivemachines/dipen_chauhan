require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_login" do
    user = User.new(email: "to@example.org")
    user.login_token = "login-token"
    mail = UserMailer.account_login(user)

    assert_equal "Account Login", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "get.dipen@gmail.com" ], mail.from
    assert_includes mail.text_part.body.decoded, "login-token"

    Premailer::Rails::Hook.perform(mail)

    html = mail.html_part.body.decoded
    assert_match(/background-color:\s*#101010|bgcolor="\#101010"/, html)
    assert_match(/background-color:\s*#e30613/, html)
    assert_includes html, "https://dipenchauhan.com/icon.png"
    assert_includes html, "Sign in"
  end
end
