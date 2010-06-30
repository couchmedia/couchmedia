module KeyboardHandler
	include EM::Protocols::LineText2

	def receive_line data
		puts "received: #{data}"
		# add files 
	end
end
