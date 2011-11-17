require 'spec_helper'

describe 'Email confirmation' do
  let(:user) { Factory.create(:user, :confirmed_at => nil) }

  it "raises record not found when confirmation token is invalid" do
    lambda {
      visit confirmation_path('invalid token')
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end

  it 'successfully confirms user email' do
    visit confirmation_path(user.confirmation_token)
    page.should have_content('confirmed successfully')
    current_path.should == confirmation_path(user.confirmation_token)
  end

  it 'does not confirm user email due to expired confirmation token' do
    user.confirmation_sent_at = 25.hours.ago and user.save
    visit confirmation_path(user.confirmation_token)
    page.should have_content('missed the deadline')
    current_path.should == confirmation_path(user.confirmation_token)
  end

  it 'does not need to confirm user email as it is already confirmed' do
    visit confirmation_path(user.confirmation_token)
    visit confirmation_path(user.confirmation_token)
    page.should have_content('has already been confirmed')
    current_path.should == confirmation_path(user.confirmation_token)
  end

  it 'does not let unconfirmed user login in' do
    login(user)
    page.should have_content('Invalid login or password')
    current_path.should == login_path
  end

  it 'should allow user to sign up again' do
    user = Factory.build(:user, :confirmed_at => nil)

    sign_up(user)
    User.count.should == 1

    # ...user does not confirm their email (spam filter cought the email, confirmation_token expired, ...)

    sign_up(user)
    User.count.should == 2

    User.all.each { |u| u.email.should == user.email }
  end

end

