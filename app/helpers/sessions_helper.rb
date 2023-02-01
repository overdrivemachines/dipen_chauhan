module SessionsHelper
  # Logs in the user:
  # - sets session[:user_id]
  # - creates new login token
  # - sets session[:login_token]
  def log_in(user)
    # Place a temporary cookie on the user’s browser
    # containing an encrypted version of the user’s id.
    # Expires immediately when the browser is closed.
    session[:user_id] = user.id

    # create new login token
    # e.g. token = ZKZOh2N7iPPGHXSPx5incQ
    token = User.new_token

    # setting user.login updates user.login_digest
    # user.login_digest = $2a$12$hd3Ey3gEjEXGpMiKeqmQYOd9oXeL2kiYGZbBZx8qeb0Y0PBJmkMGa
    user.login = token

    # TODO: reset login_sent_at

    # save new login token in session
    session[:login_token] = token

    # save user with new login token to database
    user.save
  end

  # Returns the current logged-in user (if any)
  def current_user
    # Check if session[:user_id] is present
    user_id = session[:user_id]
    return if user_id.nil?

    # get the user having id as user_id
    user = User.find_by(id: user_id)
    return if user.nil?

    # if user and login_token combination is valid
    @current_user = user if user&.authenticate_login(session[:login_token])
  end

  # if user is not logged in redirect to login page
  def authenticate_user!
    return unless current_user.nil?

    redirect_to login_path
  end

  # return true if user is signed in
  # return false if user is not signed in
  def user_signed_in?
    return true if current_user

    false
  end

  def log_out
    session.delete(:user_id)
    session.delete(:login_token)
    if !current_user.nil?
      @current_user.login_digest = nil
      @current_user.login_sent_at = nil
      @current_user.save
    end
  end
end
