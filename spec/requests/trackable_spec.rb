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

    # Rails integration tests don't have access to the request object (so we can't mock it), hence this hack
    it 'correctly updates the last_login_ip attribute' do
      post login_path, { :email => user.email, :password => user.password }, { 'REMOTE_ADDR' => 'some_address' }
      user.reload
      user.last_login_ip.should == 'some_address'
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

  it 'updates the last_activity_at attribute' do
    Timecop.freeze
    login(user)
    user.reload
    user.last_activity_at.should == Time.zone.now

    Timecop.return

    Timecop.freeze
    visit edit_current_user_path
    user.reload
    user.last_activity_at.should == Time.zone.now
  end
end

