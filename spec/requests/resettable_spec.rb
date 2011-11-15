require 'spec_helper'

describe 'Password reset' do
  before { reset_email }

  context 'when the user is signed up' do
    let(:user) { Factory(:user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago) }

    it 'emails reset instructions to the user when he requests password reset' do
      visit login_path
      click_link 'password'
      current_path.should == new_password_reset_path

      fill_in "Email", :with => user.email
      click_button "Reset password"

      current_path.should == root_path
      page.should have_content("Email sent")
      last_email.to.should include(user.email)
    end

    it 'requires the user to fill in a new password' do
      visit edit_password_reset_path(user.password_reset_token)
      click_button "Update Password"
      page.should have_content("Password must be present")
    end

    it "updates the user password when confirmation matches" do
      visit edit_password_reset_path(user.password_reset_token)
      fill_in "Password", :with => "foobar"
      click_button "Update Password"
      page.should have_content("Password doesn't match confirmation")

      fill_in "Password", :with => "foobar"
      fill_in "Password confirmation", :with => "foobar"
      click_button "Update Password"
      page.should have_content("Password has been reset")
    end

    it "reports when password token has expired" do
      user.update_attribute :password_reset_sent_at, 5.hour.ago
      visit edit_password_reset_path(user.password_reset_token)
      fill_in "Password", :with => "foobar"
      fill_in "Password confirmation", :with => "foobar"
      click_button "Update Password"
      page.should have_content("Password reset has expired")
    end

  end

  context 'when the user is not signed up' do
    it 'does not email the reset instructions but still redirects with a success notice' do
      visit new_password_reset_path
      fill_in "Email", :with => "some@email.com"
      click_button "Reset password"
      current_path.should == root_path
      page.should have_content("Email sent")
      last_email.should be_nil
    end
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end

end

