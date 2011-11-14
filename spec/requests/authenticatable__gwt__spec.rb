# This variant of the authenticatable spec uses the given_when_then gem.
# While the output is nicely descriptive, like a narrative, it's was
# rather difficult to describe the logic with all the nested whens and thens.

require 'spec_helper'

describe 'Signing up' do
  Given 'there is a guest user' do
    let(:user) { stub('user', :name => 'Mr Bean', :email => 'bean@example.com', :password => 'secret' ) }

    When 'he goes to the home page' do
      before { visit root_path }

      Then 'he should see the navigational links' do
        page.should have_content 'Sign up or Log in'
      end

      When 'he clicks the Sign up link' do
        before { visit signup_path }

        Then 'he should be presented with a signup form' do
          page.should have_selector 'div[id="signup_form"]'
        end

        When 'he fills the form with his credentials and clicks the Sign up button' do
          before do
            fill_in 'Name', :with => user.name
            fill_in 'Email', :with => user.email
            fill_in 'Password', :with => user.password
            fill_in 'Confirm Password', :with => user.password
            click_button 'Sign up'
          end

          Then 'he should be signed up successfully' do
            page.should have_content('Signed up!')
            current_path.should == root_path
            User.count.should == 1
          end
        end

        When 'he clicks the Sign up button without filling in his credentials' do
          Then 'he should see an error message' do
            click_button 'Sign up'
            page.should have_content('errors prohibited')
            User.count.should == 0
          end

          And 'the path to the form should be the signup_path (see routes.rb)' do
            current_path.should == signup_path
          end
        end

      end
    end
  end
end

describe 'Logging in' do
  Given 'a signed up user who is on the home page' do
    let(:user) { Factory(:user) }
    before { visit root_path }

    When 'he follows the login link' do
      before { click_link 'Log in' }

      Then 'he should be presented with the login form' do
        page.should have_selector 'div[id="login_form"]'
      end

      When 'he fills the login form with his credentials' do
        before do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => user.password
          click_button 'Log in'
        end

        Then 'he should be logged in' do
          page.should have_content('Logged in successfully')
        end

        And 'he should see his email address' do
          within 'div#user_nav' do
            page.should have_content(user.email)
            current_path.should == dashboard_path
          end
        end
      end

      When 'he clicks the Login button' do
        before { click_button 'Log in' }

        Then 'he should see an error message' do
          page.should have_content('Invalid login or password')
        end

        And 'the path to the login form should be the login_path' do
          current_path.should == login_path
        end
      end

    end
  end
end

describe 'Logging out' do
  Given 'there is a logged in in user' do
  let(:user) { Factory(:user) }
  let!(:last_token) { user.remember_token }
  before do
    visit login_path
    login
  end

    When 'he clicks the Logout link' do
      before { click_link 'Log out' }

      Then 'he should log out' do
        page.should have_content('You have been logged out')
      end

      And "his remember_token should be reset" do
        user.reload
        user.remember_token.should_not == last_token
      end
    end
  end
end


describe 'Editting profile' do
  Given 'there is a logged in user' do
    let(:user) { Factory(:user) }
    before do
      visit login_path
      login
    end

    When 'he clicks the Edit profile link' do
      before { visit edit_current_user_path }

      Then 'he should be presented with the signup form' do
        page.should have_selector('div[id="signup_form"]')
      end

      And 'the form should have an Update button' do
        within 'div#signup_form' do
          page.should have_button('Update')
        end
      end

      When 'he fills the form with a new name and clicks the Update button' do
        let!(:last_name) { user.name }
        before do
          fill_in 'Name', :with => 'A new name'
          click_button 'Update'
        end

        Then 'the name should change' do
          user.reload
          user.name.should_not == last_name
        end
      end
    end
  end
end


# eof

