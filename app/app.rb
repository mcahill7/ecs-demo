require 'sinatra/base'
require 'json'

# Stelligent DemoApp
class DemoApp < Sinatra::Application
  get '/' do
    content_type :json
    {
      message: message,
      timestamp: timestamp
    }.to_json
  end

  def timestamp
    Time.now.to_i
  end

  def message
    'Automation for the People'
  end
end
