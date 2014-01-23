require 'rubygems'
require 'thread'
require 'socket'
require 'ruby-hl7'

TCP_IP = '192.168.1.39'
PORT = 2100

def parseHL7(raw_data)
	hl7 = HL7::Message.new(raw_data)
	puts "Recieved HL7 message with #{hl7.length} segments"
 
	if hl7[:PID] 
		#Save patient data if patient doesn't already exist.
		if !Patient.find_by_mrn(hl7[:PID].patient_id_list)
			p = Patient.create(
				mrn: hl7[:PID].patient_id_list,
				surname: hl7[:PID].patient_name.split('^')[0]
			)
		else
			p = Patient.find_by_mrn(hl7[:PID].patient_id_list)
		end
		if o = Observation.create(
			patient: p,
			recorded_at: DateTime.parse(hl7[:OBR].e7, "%Y%m%d%H%M%S")
		)
			#Loop through OBXs and save relevant patient data 
			hl7[:OBX].each do |segment|
				case segment.observation_id.first(9) 
				when'0002-4182'
					m = PulseMeasurement.new
				when '0002-4a05'
					m = SysBpMeasurement.new
				when '0002-4a06'
					m = DiaBpMeasurement.new
				when '0002-500a'
					m = RespirationRateMeasurement.new
				when '0401-0b54'
					m = TemperatureMeasurement.new
				end
				if m
					m.observation = o
					m.value = segment.observation_value
					m.save
				end
			end
		end
		puts "All data parsed."
	end
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
	p ack.to_mllp
	ack.to_mllp.sub("\u001C\r","\r\u001C\r")
end


Thread.new do
	Thread.abort_on_exception = true #Kill any useless failure threads

	srv = TCPServer.open(TCP_IP, PORT)
	puts "proxy_server listening on port: %i" % PORT

	loop do
		Thread.start(srv.accept) do |message|
			puts "Recieved message"
			# message.puts "\vMSH|^~\\&|||||20140122192021||ACK^^ACK_ALL|US232012490000000018|P|2.4\rMSA|AA|US232012490000000018\u001C\r"
			raw_data = ""
			# This first section (looping through the data may be unecessary)
			# raw_data = message.read

			while (m = message.recv(10))
				raw_data += m
				break if raw_data.include? "\r\x1C\r"
			end
			p raw_data
			# message.puts 
			# message.write(parseHL7(raw_data.split("\r")))
			message.puts parseHL7(raw_data.split("\r"))
			message.close
		end
	end
end

