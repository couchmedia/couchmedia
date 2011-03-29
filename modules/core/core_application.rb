require "sinatra"

class CoreApplication < Sinatra::Base
  get '/' do
    'Core'
  end
end
