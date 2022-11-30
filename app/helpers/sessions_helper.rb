module SessionsHelper
  # Logs in the user:
  # - sets session[:user_id]
  # - creates new remember_digest
  # - sets session[:remember_digest]
  # - resets user.login_digest
  def log_in(user)
    # Places a temporary cookie on the user’s browser
    # containing an encrypted version of the user’s id.
    # Expires immediately when the browser is closed.
    session[:user_id] = user.id

    # create new remember digest
    user.remember_digest = User.digest(User.new_token)

    # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:remember_digest] = user.remember_digest

    # make login link invalid by resetting the login_digest
    user.login = User.new_token
    user.save
  end

  def log_out
    session.delete(:user_id)
    session.delete(:remember_digest)
  end
end
