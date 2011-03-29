require 'rack-proxy'
require 'pp'

class DatabaseApplication < Rack::Proxy
  def rewrite_env(env)
    env["HTTP_HOST"] = "www.google.com"
    env["SERVER_PORT"] = "80"
    env["REQUEST_URI"].sub!("/db","")
    env["REQUEST_PATH"].sub!("/db","")
    env["SCRIPT_NAME"].sub!("/db","")
    pp env
    env
  end

  def rewrite_response(triplet)
    status, headers, body = triplet
    
    headers.delete("Location")
    
    triplet
  end
end
