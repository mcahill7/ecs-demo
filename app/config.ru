ENV['RACK_ENV'] = 'production'

require File.dirname(__FILE__) + '/app'

run DemoApp
