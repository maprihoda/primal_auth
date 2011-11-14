class SessionsController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      if params[:remember_me]
        cookies[:remember_token] = { :value => user.remember_token, :expires => 24.weeks.from_now }
      else
        cookies[:remember_token] = user.remember_token
      end

      redirect_to dashboard_url, :notice => "Logged in successfully."
    else
      flash.now[:alert] = "Invalid login or password."
      render 'new'
    end

  end

  def destroy
    current_user.reset_remember_token!
    cookies.delete(:remember_token)
    reset_session

    redirect_to root_url, :notice => "You have been logged out."
  end
end

