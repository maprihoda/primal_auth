class PasswordResetsController < ApplicationController
  skip_before_filter :login_required

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    # NB: this redirect is OK as we don't want to disclose that the user doesn't exist (if it doesn't)
    redirect_to root_url, :notice => "Email sent with password reset instructions."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])

    # we should require the password to be present (unlike when editting user profile)
    unless params[:user][:password].present?
      @user.errors.add(:password, 'must be present')
      render :edit and return
    end

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end

