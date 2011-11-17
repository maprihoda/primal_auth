class UsersController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create, :confirmation_needed]

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
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render 'edit'
    end
  end
end

