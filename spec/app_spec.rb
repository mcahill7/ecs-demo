require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../app/app.rb'

RSpec.describe 'Stelligent DemoApp' do
  include Rack::Test::Methods

  def app
    DemoApp
  end

  it 'is healthy' do
    get '/'

    expect(last_response).to be_ok
  end

  it 'says timestamp' do
    get '/'
    timestamp = Time.now.to_i

    expect(JSON.parse(last_response.body)['timestamp']).to match(timestamp)
  end

  it 'says message' do
    get '/'
    message = 'Automation for the People'

    expect(JSON.parse(last_response.body)['message']).to match(message)
  end
end
