require 'spec_helper'

describe 'Authenticating with Omniauth' do
  it 'log in with omniauth' do
    login_with_omniauth
    page.should have_content('Logged in successfully')
    current_path.should == dashboard_path

    user = User.first
    page.should have_content(user.name)

    page.should_not have_content('Edit profile')
  end

  it 'log out after logging in with omniauth' do
    login_with_omniauth
    logout
    page.should have_content('You have been logged out')
  end

  it 'logging in with invalid credentials' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    login_with_omniauth
    current_path.should == root_path
    page.should have_content('Authentication error')
  end
end

