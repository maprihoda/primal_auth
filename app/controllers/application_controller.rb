class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery

  before_filter :login_required
end

