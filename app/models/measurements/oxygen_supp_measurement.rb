class OxygenSuppMeasurement < ActiveRecord::Base
	include MeasurementHelper
	def getNEWS
		if value 
			2
		else 
			0
		end			
	end
end
