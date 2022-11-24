class UserMailer < ApplicationMailer
  def account_login(user)
    @user = user
    mail to: user.email, subject: "Account Login"
  end
end
