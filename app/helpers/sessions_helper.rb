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
    token = User.new_token
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
    return unless user_id == session[:user_id]

    # get the user having id as user_id
    user = User.find_by(id: user_id)

    # if user and login_token combination is valid
    @current_user = user if user&.authenticate_login(session[:login_token])
  end

  def log_out
    session.delete(:user_id)
    session.delete(:remember_digest)
  end
end
