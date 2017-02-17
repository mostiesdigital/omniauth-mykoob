# OmniAuth Mykoob


OmniAuth strategy for authenticating to mykoob

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-mykoob'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-mykoob

## Usage

Add this to config/initializers/omniauth.rb

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :mykoob, 'app_id', 'api_key'
    end

