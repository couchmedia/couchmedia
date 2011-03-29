require "sinatra/base"

class SyncApplication < Sinatra::Base
  get '/' do
    'Sync'
  end
end
