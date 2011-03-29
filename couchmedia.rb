require 'rubygems'
require 'yaml'
require 'eventmachine'
require 'em-http'

require 'lib/changes_feed.rb'
require 'lib/webservice.rb'

@config = YAML::load_file('config.yml')

EventMachine.run do
	# couchmedia changes watch
	ChangesFeed::listen(@config)
	# webserver (sinatra + thin)
	Webservice.run! :port => 3000
end
