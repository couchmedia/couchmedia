require "sinatra/base"

class AuthApplication < Sinatra::Base
  get '/' do
    'Auth'
  end
end
