class ConciousMeasurement < ActiveRecord::Base
	include MeasurementHelper

	validates_inclusion_of :value, :in => ["A", "V", "P", "U"]

	def before_save 
		self.username.upcase!
	end

	def getNEWS
		if value == "3"
			0
		else 
			3
		end
	end
end
