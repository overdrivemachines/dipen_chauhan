class SessionsController < ApplicationController
  # Display login form
  # GET /login
  def new
    redirect_back(fallback_location: root_path) if user_signed_in?
  end

  # Login form has submitted/posted
  # POST /login
  # Sends email containing link to login
  def create
    # Find the user based on their email provided in the login form
    user = User.find_by(email: params[:session][:email].downcase)

    # if user exists send the login email
    if user
      # Generate new token
      user.login_token = User.new_token

      # Update login attribute of user
      # user.login_digest automatically gets updated
      user.login = user.login_token

      # Set the time when the login email was sent
      # Will be used to determine if the login link
      # is expired
      user.login_sent_at = Time.zone.now

      # save changes to DB (updating to new login_digest)
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
  # Checks if email and login token combination are valid
  # Checks if login token is expired
  # Logs the user in and redirects to the projects page
  def edit
    user = User.find_by(email: params[:email])
    token = params[:id]

    # if user exists and if token is valid, login the user
    # authenticate_login(token) checks if the token is valid
    # it is a bcrypt method
    if user && user.authenticate_login(token)
      # Check for login link expiry
      if user.login_sent_at < 2.hours.ago
        flash[:title] = "Invalid Login"
        redirect_to sessions_message_path,
                    notice: "Login link is expired. Please get a new link and try again. Login links expire after 2 hours."
      end
      # Login the user
      # log_in defined in sessions_helper.rb
      log_in(user)
      flash[:success] = "Account Logged In!"
      redirect_to projects_path
    else
      flash[:title] = "Invalid Login"
      redirect_to sessions_message_path,
                  notice: "Login link is invalid. Please get a new link and try again."
    end
  end

  # GET /sessions/message
  def message
    redirect_to root_path if flash[:title].nil?
  end

  # Logout
  # DELETE /logout
  def destroy
    # defined in session_helper.rb
    log_out
    redirect_back(fallback_location: root_path)
  end
end
