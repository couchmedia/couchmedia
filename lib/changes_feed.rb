require 'json'

class ChangesFeed
	def self.stream config
		@@last_seq ||= 0
		req = EventMachine::HttpRequest.new("http://#{config['host']}:#{config['port']}/#{config['database']}/_changes?feed=continuous&since=#{@@last_seq}&heartbeat=30000").get(:timeout => 0)
		req.stream do |chunk|
			unless chunk.length < 2
 				doc = JSON.parse(chunk)
 				if doc['id'].nil?
					@@last_seq = doc['last_seq']
 				else
 					@@last_seq = doc['seq']

					puts doc.inspect
					# handle all changes
 					
				end
 			end
  	end
  	# handle possible errors of the stream
		req.errback do
			puts "error"
		end
		# reconnect the stream if we get disconnected
		# this should not occur due to the heartbeat 
		# couchdb is supposed to send each 30 seconds
  	req.callback do
  		stream config
  	end
	end
end
