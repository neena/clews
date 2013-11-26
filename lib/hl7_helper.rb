module HL7Helper
	def parseHL7Segment(raw_input)
		"HL7::Message::Segment::#{raw_input[0...3]}".constantize.new( raw_inp )
	end

	def saveData(raw_input)
		if raw_input.is_a? String
			raw_input = parseHL7Segment(raw_input)
		end
		if raw_input.instance_of? HL7::Message::Segment::OBX
		elsif raw_input.instance_of? HL7::Message::Segment::PID
			@patient = Patient.new
			@patient.surname = raw_input[:patient_name].split('^')[0]
			@patient.surname.first.upcase!
			@patient.MRN = raw_input[:patient_id]
			@patient.save
		end
	end
end