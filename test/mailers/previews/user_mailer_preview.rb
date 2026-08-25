# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_login
  def account_login
    user = User.first || User.new(email: "preview@example.com")
    user.login_token = "preview-login-token"
    UserMailer.account_login(user)
  end
end
