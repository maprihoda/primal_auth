require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include HelperMethods
  config.include ShowMeTheCookies
  config.include MailerMacros

end

# http://calicowebdev.com/2011/01/25/rails-3-sqlite-3-in-memory-databases/
# We are using sqlite3 and the in-memory database, so this is enough
puts "creating sqlite in memory database"
load "#{Rails.root}/db/schema.rb"

