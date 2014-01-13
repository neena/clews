class PulseMeasurement < Measurement
	def self.units
		"bpm"
	end
	def getNEWS
		case 
		when value >= 131 || value <= 40
			3
		when value >= 111
			2
		when value >= 91 || value <= 50
			1
		else 
			0
		end			
	end
end
