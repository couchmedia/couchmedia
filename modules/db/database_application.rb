require 'rack-proxy'

class DatabaseApplication < Rack::Proxy
  def rewrite_env(env)
    env["HTTP_HOST"] = CouchMedia.conf['database']['host']
    env["SERVER_PORT"] = CouchMedia.conf['database']['port']
    env["REQUEST_URI"].sub!("/db","")
    env["REQUEST_PATH"].sub!("/db","")
    env["SCRIPT_NAME"].sub!("/db","")
    env
  end

  def rewrite_response(triplet)
    status, headers, body = triplet
    headers.delete("Location")
    triplet
  end
end
