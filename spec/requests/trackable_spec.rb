require 'spec_helper'

describe 'Tracking user' do
  let(:user) { Factory(:user) }

  context 'on login' do
    before do
      Timecop.freeze
      login(user)
      user.reload
    end

    it 'updates the trackable attributes' do
      user.last_login_at.should_not be_nil
      user.last_login_ip.should_not be_nil
      user.login_count.should == 1
    end

    it 'saves the time the user logged in' do
      user.last_login_at.should == Time.zone.now
    end

  end

  context 'on logout' do
    before do
      Timecop.freeze
      login(user)
      logout
      user.reload
    end

    it 'updates the trackable attributes' do
      user.last_logout_at.should_not be_nil
    end

    it 'saves the time the user logged out' do
      user.last_login_at.should == Time.zone.now
    end

  end

end

