class RespirationRateMeasurement < Measurement
	
	def getNEWS
		case 
		when value <= 8 || value >= 25
			3
		when value >= 21
			2
		when value <= 11
			1
		else 
			0
		end			
	end
end
