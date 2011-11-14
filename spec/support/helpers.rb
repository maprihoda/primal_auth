module HelperMethods

  def login
    visit login_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Log in'
  end

  def logout
    click_link 'Log out'
  end

  def should_be_on(path)
    current_path.should == path
  end

end

RSpec.configuration.include HelperMethods, :type => :request

