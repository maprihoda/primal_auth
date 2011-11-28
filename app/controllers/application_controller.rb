class ApplicationController < ActionController::Base
  protect_from_forgery

  # NB: the order of the after filters is important - the first one declared
  # will be the last one executed (so our user object will be saved with all
  # attributes updated)
  after_filter :save_current_user_if_dirty, :update_last_activity_at

  before_filter :login_required

  helper_method :current_user, :logged_in?

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

  # NB: last_activity_at is not updated on logout as we don't have current_user
  def update_last_activity_at
    current_user.last_activity_at = Time.zone.now if current_user
  end

  def save_current_user_if_dirty
    current_user.save!(:validate => false) if current_user && current_user.changed?
  end
end

