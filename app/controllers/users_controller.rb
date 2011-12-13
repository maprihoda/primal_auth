class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to :action => :confirmation_needed, :controller => :confirmations
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    render_edit_template
  end

  def update
    @user = current_user

    if params[:user][:email].present? && params[:user][:email] != @user.email
      @user.confirmed_at = nil
      @user.attributes = params[:user]
      @user.send_confirmation_instructions

      @user.logout(cookies)
      reset_session

      redirect_to :action => :confirmation_needed, :controller => :confirmations
      return
    end

    if @user.update_attributes(params[:user])
      redirect_to dashboard_url, :notice => "Your profile has been updated."
    else
      render_edit_template
    end
  end

private

  def render_edit_template
    params['oauth'].present? ? render('edit_with_oauth') : render('edit')
  end
end

