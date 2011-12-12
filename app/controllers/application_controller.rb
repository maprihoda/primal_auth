class ApplicationController < ActionController::Base
  protect_from_forgery

  include Authentication

  # NB: the order of the after filters is important - the first one declared
  # will be the last one executed (so our user object will be saved with all
  # attributes updated)
  after_filter :save_current_user_if_dirty, :update_last_activity_at

end

