class SessionsController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  def new
  end

  def create
    @current_user = User.authenticate(params[:email], params[:password])

    if @current_user
      @current_user.track_on_login(request)

      if params[:remember_me]
        cookies[:remember_token] = { :value => @current_user.remember_token, :expires => 24.weeks.from_now }
      else
        cookies[:remember_token] = @current_user.remember_token
      end

      redirect_to dashboard_url, :notice => "Logged in successfully."
    else
      flash.now[:alert] = "Invalid login or password."
      render 'new'
    end
  end

  def destroy
    current_user.logout(cookies)
    reset_session

    redirect_to root_url, :notice => "You have been logged out."
  end
end

