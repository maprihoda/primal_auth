class ApplicationController < ActionController::Base
  include Authentication

  # NB: the order of the filters is important - the first one declared
  # will be the last one executed
  after_filter :save_current_user_if_dirty, :update_last_activity_at

  protect_from_forgery

  before_filter :login_required
end

