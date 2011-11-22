require 'spec_helper'

describe 'Remember me' do
  let(:user) { Factory(:user) }
  before do
    visit login_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
  end

  it "remember user so they don't have to log in after they come back" do
    check 'Remember me'
    click_button 'Log in'
    page.should have_content(user.email)
    current_path.should == dashboard_path

    # simulate closing the browser
    # this deletes the session cookie and any expired cookies so our remember_me cookie stays untouched
    # (see the show_me_the_cookies gem)
    expire_cookies

    visit dashboard_path
    page.should have_content(user.email)
    current_path.should == dashboard_path
  end

  it "do not remember user if they don't check the 'Remember me' checkbox" do
    click_button 'Log in'
    page.should have_content(user.email)
    current_path.should == dashboard_path

    expire_cookies
    visit dashboard_path
    current_path.should == login_path
  end
end

