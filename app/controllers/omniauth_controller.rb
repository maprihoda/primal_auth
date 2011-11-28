class OmniauthController < ApplicationController
  skip_before_filter :login_required

  def create
    auth = request.env["omniauth.auth"]
    @current_user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    @current_user.track_on_login(request)

    if params[:remember_me]
      cookies[:remember_token] = { :value => @current_user.remember_token, :expires => 24.weeks.from_now }
    else
      cookies[:remember_token] = @current_user.remember_token
    end

    redirect_to dashboard_url, :notice => "Logged in successfully with #{auth['provider'].capitalize}."
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end

