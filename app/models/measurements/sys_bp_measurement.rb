class SysBpMeasurement < Measurement
	def self.units
		"mmHg"
	end
	def getNEWS
		case 
		when value <= 90 || value >= 220
			3
		when value <= 100
			2
		when value <= 110
			1
		else 
			0
		end	
	end
end
