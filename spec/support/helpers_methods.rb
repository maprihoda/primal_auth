module HelperMethods
  def sign_up(user)
    visit signup_path
    page.should have_selector 'div[id="signup_form"]'
    fill_in 'Name', :with => user.name
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    fill_in 'Confirm Password', :with => user.password
    click_button 'Sign up'
  end

  def login(user)
    visit login_path
    page.should have_selector 'div[id="login_form"]'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Log in'
  end

  def login_with_omniauth(service = :github)
    visit "/auth/#{service}"
  end

  def logout
    click_link 'Log out'
  end

  def should_be_on(path)
    current_path.should == path
  end
end

