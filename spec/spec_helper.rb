$LOAD_PATH.unshift(File.expand_path('.'))

ENV['RACK_ENV'] ||= 'test'

require 'capybara/rspec'
require 'app'
require 'shoulda-matchers'
require 'models/listing'
require 'models/user'

Capybara.app = Sinatra::Application




