require 'sinatra/base'
require 'thin'

class Webservice < Sinatra::Base
	post '/add' do
		"{ nothing: \"yet\" }"
	end

	get '/statistics' do
		"{ nothing: \"yet\" }"
	end

	get '/' do
		"{ nothing: \"yet\" }"
	end
end
