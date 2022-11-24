class SessionsController < ApplicationController
  # Display login form
  def new; end

  # Login form has posted
  def create
    # Find the user based on their email provided in the login form
    user = User.find_by(email: params[:session][:email].downcase)

    # if user exists send the login email
    if user
      # Send email to user
      UserMailer.account_login(user)
    end

    # Redirect to page stating that email was sent
    redirect_to message_sessions_path,
                notice: "If an account for your email exists, the login link has been emailed to you."
  end

  def message; end

  # Logout
  def destroy; end
end
