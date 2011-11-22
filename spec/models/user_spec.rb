require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }
  before { reset_email }

  context 'validations' do
    it 'the user should be allowed to edit her profile without providing the password' do
      user.update_attributes(:name => 'Mrs New').should be_true
    end
  end

  context 'authentication' do
    it 'should return the user object if the credentials match' do
      User.authenticate(user.email, user.password).should == user
    end

    it 'should return nil if the credentials do not match' do
      User.authenticate('wrong email', 'wrong password').should be_nil
    end
  end

  context 'generating and resetting the remember_token' do
    it 'generates the remember token on user#create' do
      user.remember_token.should_not be_nil
    end

    it 'it resets the remember token to a new value' do
      last_token = user.remember_token
      user.reset_remember_token_and_save
      user.reload
      user.remember_token.should_not == last_token
    end
  end

  context 'password reset' do
    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not == last_token
    end

    it "saves the time the password reset was sent" do
      Timecop.freeze
      user.send_password_reset
      Time.use_zone("Prague") do
        user.reload.password_reset_sent_at.should == Time.zone.now
      end
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end

  context 'email confirmation' do
    it 'generates the confirmation_token on user#create' do
      user.confirmation_token.should_not be_nil
    end

    it 'saves the time the confirmation_token was sent' do
      Timecop.freeze
      user.send_confirmation_instructions
      user.reload.confirmation_sent_at.should == Time.zone.now
    end

    it "delivers email to user" do
      user.send_confirmation_instructions
      last_email.to.should include(user.email)
    end

    it 'confirms user' do
      user.confirm!
      user.confirmed?.should be_true
    end

  end

  it 'deletes unconfimed users after 24 hours since sending them the confirmation token' do
    user = Factory.create(:user, :confirmed_at => nil)
    user.confirmation_sent_at = 25.hours.ago and user.save
    User.count.should == 1
    User.delete_unconfirmed.should == 1
  end

end








# eof

