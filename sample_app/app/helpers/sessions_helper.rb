module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    @current_user ||= find_user_from_session || find_user_from_cookies
  end

  def logged_in?
    current_user.present?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  private

  def find_user_from_session
    user_id = session[:user_id]
    User.find_by(id: user_id) if user_id
  end

  def find_user_from_cookies
    user_id = cookies.encrypted[:user_id]
    return unless user_id

    user = User.find_by(id: user_id)
    if user && user.authenticated?(cookies[:remember_token])
      log_in(user)
      user
    end
  end
end
