class TemperatureMeasurement < ActiveRecord::Base
	include MeasurementHelper

	def getNEWS
		case 
		when value <= 35
			3
		when value >= 39.1
			2
		when value >= 38.1 || value <= 36
			1
		else 
			0
		end			
	end
end
