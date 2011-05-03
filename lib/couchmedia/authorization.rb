require 'rack'
require 'json'
require 'net/http'

require 'couchmedia'

require 'pp'

class CouchAuthorization
  def initialize(app)
    @app = app
    @db = CouchMedia.conf['database']
  end

  def call(env)
    request = Rack::Request.new(env)
    request_method = request.request_method
    path = request.path
    auth ||= Rack::Auth::Basic::Request.new(env)

    if not auth.provided?
      return [401, {"Content-Type" => "text/plain", "Content-Length" => "0", "WWW-Authenticate" => "Basic realm=\"CouchMedia\""}, []]
    end
    username, password = auth.credentials

    # check password
    begin
      user_pass = JSON.parse(Net::HTTP.get(URI::HTTP.build({:host => @db['host'], :port => @db['port'], :path => "/#{@db['name']}/_design/authorization/_view/user_pass", :query => "key=%22#{username}%22"})))
    end

    unless user_pass['rows'][0] && user_pass['rows'][0]['value'] == password
      return [401, {"Content-Type" => "text/plain", "WWW-Authenticate" => "Basic realm=\"CouchMedia\""}, ["Invalid credentials"]]
    end

    # check permissions
    begin
      startkey = URI.escape("[\"#{username}\",{}]")
      endkey = URI.escape("[\"#{username}\"]")      
      permissions = JSON.parse(Net::HTTP.get(URI::HTTP.build({:host => @db['host'], :port => @db['port'], :path => "/#{@db['name']}/_design/authorization/_view/permissions", :query => "startkey=#{startkey}&endkey=#{endkey}&descending=true"})))
    end
    
    permissions['rows'].each do |permission|
      puts path
      if "#{path}/" =~ /^#{permission['key'][1]}\// && request_method == permission['value']
        env.delete("HTTP_AUTHORIZATION")
        return @app.call(env)
      end
    end

    return [200, {"Content-Type" => "text/plain"}, ["Action not authorized"]]
  end
end
