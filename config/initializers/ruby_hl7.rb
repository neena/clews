require 'rubygems'
require 'thread'
require 'socket'
require 'ruby-hl7'

def parseHL7(raw_data)
	hl7 = HL7::Message.new(raw_data)
	puts "Recieved HL7 message with #{hl7.length} segments"
 
	if hl7[:PID] 
		#Save patient data if patient doesn't already exist.
		if !Patient.find_by_mrn(hl7[:PID].patient_id_list)
			p = Patient.new
			p.mrn = hl7[:PID].patient_id_list
			p.surname = hl7[:PID].patient_name.split('^')[0]
			p.save
		else
			p = Patient.find_by_mrn(hl7[:PID].patient_id_list)
		end

		#Loop through OBXs and save relevant patient data 
		hl7[:OBX].each do |segment|
			case segment.observation_id.first(9) 
			when'0002-4182'
				m = PulseMeasurement.new
				m.patient = p
				m.value = segment.observation_value
				if segment.observation_date.blank?
					m.datetime = DateTime.now 
				else
					m.datetime = DateTime.parse(segment.observation_date, "%Y%m%d%H%M%S")
				end
				m.save
			end
		end
		puts "All data parsed."

		#Generate ACK
		puts "HL7 parsed and saved! Attempting to send ACK."
		ack = HL7::Message.new
		msh = HL7::Message::Segment::MSH.new
		msh.enc_chars = '^~\&'
		msh.message_type = "ACK^^ACK_ALL"
		msh.time = DateTime.now.strftime("%Y%m%d%H%M%S")
		msh.message_control_id = hl7.first.e9
		msh.processing_id = "P"
		msh.version_id = "2.4"
		ack << msh
		msa = HL7::Message::Segment::MSA.new
		msa.ack_code = "AA"
		msa.control_id = hl7.first.e9
		ack << msa
		p ack.to_hl7
		ack.to_hl7 + "\r"
	end
end


Thread.new do
	TCP_IP = '127.0.0.1'
	PORT = 2100
	Thread.abort_on_exception = true #Kill any useless failure threads

	srv = TCPServer.open(TCP_IP, PORT)
	puts "proxy_server listening on port: %i" % PORT

	loop do
		Thread.start(srv.accept) do |message|
			puts "Recieved message"

			# This first section (looping through the data may be unecessary)
			raw_data = ""
			while (m = message.recv(10))
				raw_data += m
				break if m.empty? 
			end
			p raw_data
			message.write(parseHL7(raw_data.split("\r")))
		end
	end
end

