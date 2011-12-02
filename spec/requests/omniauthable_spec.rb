require 'spec_helper'

describe 'Authenticating with Omniauth' do
  it 'log in with omniauth' do
    login_with_omniauth
    page.should have_content('Logged in successfully')
    current_path.should == dashboard_path

    user = User.first
    page.should have_content(user.name)

    page.should have_content('Edit profile')
  end

  it 'logging in with invalid credentials' do
    github = OmniAuth.config.mock_auth[:github]
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    login_with_omniauth
    current_path.should == root_path
    page.should have_content('Authentication error')

    OmniAuth.config.mock_auth[:github] = github
  end

  it 'log out after logging in with omniauth' do
    login_with_omniauth
    logout
    page.should have_content('You have been logged out')
  end

  it 'should edit profile successfully' do
    login_with_omniauth
    user = User.first
    visit edit_current_user_path(:oauth => 1)

    page.should have_selector(%Q(input[value="#{user.name}"]))

    find_field('Email').value.should be_blank
    user.email.should be_nil

    fill_in 'Email', :with => 'email@example.com'
    click_button 'Update'
    user.reload
    user.email.should == 'email@example.com'
  end
end

