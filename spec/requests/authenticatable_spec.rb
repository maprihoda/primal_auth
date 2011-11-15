require 'spec_helper'

describe 'Signing up' do
  let(:user) { Factory.build(:user) }
  before do
    visit signup_path
    page.should have_selector 'div[id="signup_form"]'
  end

  it 'with correct credentials' do
    fill_in 'Name', :with => user.name
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    fill_in 'Confirm Password', :with => user.password
    click_button 'Sign up'

    page.should have_content('Signed up!')
    current_path.should == root_path
    User.count.should == 1
  end

  it 'with incorrect credentials' do
    click_button 'Sign up'
    page.should have_content('errors prohibited')
    current_path.should == signup_path
    User.count.should == 0
  end
end

describe 'Logging in' do
  let(:user) { Factory(:user) }
  before { visit root_path }

  it 'with correct credentials' do
    click_link 'Log in'
    page.should have_selector 'div[id="login_form"]'

    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Log in'

    page.should have_content('Logged in successfully')
    page.should have_content(user.email)
    current_path.should == dashboard_path
  end

  it 'with incorrect credentials' do
    click_link 'Log in'
    click_button 'Log in'

    page.should have_content('Invalid login or password')
    current_path.should == login_path
  end
end

describe 'Logging out' do
  let(:user) { Factory(:user) }
  let!(:last_token) { user.remember_token }
  before { login }

  it 'should log out successfully' do
    click_link 'Log out'
    page.should have_content('You have been logged out')

    user.reload
    user.remember_token.should_not == last_token
  end
end

describe 'Editting profile' do
  let(:user) { Factory(:user) }
  let!(:last_name) { user.name }
  before { login }

  it 'should edit profile successfully' do
    visit edit_current_user_path
    within 'div#signup_form' do
      page.should have_button('Update')
    end

    fill_in 'Name', :with => 'A new name'
    click_button 'Update'
    user.reload
    user.name.should_not == last_name
  end

end

describe 'Login required for not logged in users' do
  it 'should redirect to the login page' do
    visit dashboard_path
    current_path.should == login_path
  end
end

