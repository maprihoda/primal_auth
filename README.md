# primal_auth

A Ruby on Rails example application with authentication built from scratch.


## Motivation

Full-featured gems like Devise are great authentication solutions, especially suitable e.g. when quickly prototyping a new application. However, I prefer to implement authentication from scratch as it's easier for me to fully understand and later maintain/extend it.


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

* confirmable
* CouchDB fork


## Credits

The core of the application is based on the example application Ryan Bates used in his railscasts on authentication ([railscasts on authentication](http://asciicasts.com/tags/authentication)).

