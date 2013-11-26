def parseHL7(raw_data)
	raw_data = raw_data.split("\r")
	hl7 = HL7::Message.new(raw_data)
	puts hl7.length
	if hl7[:PID]
		p = Patient.new
		p.MRN = hl7[:PID].patient_id_list
		p.surname = hl7[:PID].patient_name.split('^')[0]
		p.save
	end
end


Thread.new do
	require 'rubygems'
	require 'thread'
	require 'socket'
	require 'ruby-hl7'

	TCP_IP = '192.168.1.39'
	PORT = 2100
	BUFFER = 10
	Thread.abort_on_exception = true

	srv = TCPServer.open(TCP_IP, PORT)
	puts "proxy_server listening on port: %i" % PORT

	loop do
		Thread.start(srv.accept) do |message|
			raw_data = ""
			while (m = message.recv(10))
				raw_data += m
				break if m.empty? 
			end
			parseHL7(raw_data)
		end
	end
end
