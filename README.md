# primal_auth

A Ruby on Rails example application with authentication built from scratch.


## Motivation

Full-featured solutions like the Devise engine are often a good choice when authentication is needed. However, I prefer to implement authentication in a Rails app from scratch as I find it much easier to customize than a Rails engine.


## Tell me more

The authentication needs covered are:

* Signing up
* Confirming sign-up by email
* Logging in/out
* Remembering logged in user
* Resetting password


The application is inspired by Ryan Bates' excellent [railscasts on authentication](http://asciicasts.com/tags/authentication) and the [nifty_authentication generator](https://github.com/ryanb/nifty-generators/blob/master/rails_generators/nifty_authentication/USAGE). I made several modifications to the original code base, added other features (Confirmable), wired everything together into a fully functional Ruby on Rails application, and thoroughly tested everything (mainly unit and integration tests with RSpec and Capybara).

It also takes inspiration from [Devise](https://github.com/plataformatec/devise).


## Installation

Just git clone the application, cd to the root folder and run

    bundle

and then

    rails server -b localhost


The app works ok on Ruby ~> 1.9.2.


## Tests

Run the tests with

    bundle exec rspec spec


## TODO

* Account cancellation
* Trackable
* Oauth
* CouchDB fork

