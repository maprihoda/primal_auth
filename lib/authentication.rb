module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?
    controller.send :after_filter, :save_current_user_if_dirty
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token].present?
  end

  def logged_in?
    current_user
  end

  def login_required
    unless logged_in?
      store_location
      redirect_to login_url, :alert => "You must first log in or sign up before accessing this page."
    end
  end

  def redirect_back_or(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  private

  def store_location
    session[:return_to] = request.url
  end

  def save_current_user_if_dirty
    current_user.save! if current_user && current_user.changed?
  end
end

