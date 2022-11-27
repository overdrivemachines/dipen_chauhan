class SessionsController < ApplicationController
  # Display login form
  # GET /login
  def new; end

  # Login form has submitted/posted
  # POST /login
  def create
    # Find the user based on their email provided in the login form
    user = User.find_by(email: params[:session][:email].downcase)

    # if user exists send the login email
    if user
      user.login_token = User.new_token
      user.save
      # Send email to user
      UserMailer.account_login(user).deliver_now
    end

    # Redirect to page stating that email was sent
    flash[:title] = "Notice"
    redirect_to sessions_message_path,
                notice: "If an account for your email exists, the login link has been emailed to you."
  end

  # Edit action gets called when user clicks on activation link in email
  # e.g. link: http://localhost:3000/sessions/ChCkiCMDIodAi6uG8-aYEw/edit?email=c%40c.com
  # Has no template
  def edit
    user = User.find_by(email: params[:email])
    login_token = params[:id]

    if user && user.authenticate_login(login_token)
      # Check for expiry
      # TODO: login user
      flash[:success] = "Account Logged In!"
      redirect_to projects_path
    else
      flash[:title] = "Invalid Login"
      redirect_to sessions_message_path,
                  notice: "Login link is invalid. Please get a new link and try again. Login links expire after 2 hours."
    end
  end

  # GET /sessions/message
  def message; end

  # Logout
  # DELETE /logout
  def destroy; end
end
