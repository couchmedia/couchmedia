require 'rubygems'
require 'yaml'
require 'mp3info'
require 'eventmachine'
require 'em-http'

require 'lib/keyboard_handler.rb'
require 'lib/changes_feed.rb'
require 'lib/webservice.rb'

@config = YAML::load_file('config.yml')

def setup_changes_stream
	
end

EventMachine.run do
	# watch add folder
	
	# use the keyboard to emulate http requests
	# debugging purpose
	EM.open_keyboard KeyboardHandler
	# couchmedia changes watch
	ChangesFeed::stream @config
	# webserver (sinatra + thin)
	Webservice.run! :port => 3000
end
