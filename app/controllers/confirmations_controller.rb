class ConfirmationsController < ApplicationController
  skip_before_filter :login_required

  def confirm
    user = User.find_by_confirmation_token!(params[:id])  # test for ActiveRecord::RecordNotFound

    # make it idempotent
    if user.confirmed?
      render 'already_confirmed' and return
    end

    if user.confirmation_sent_at >= 24.hours.ago
      user.confirm!
      render 'confirmation_successful'
    else
      render 'confirmation_token_expired'
    end
  end

  def confirmation_needed
  end
end

