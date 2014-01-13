class OxygenSatMeasurement < Measurement

	def self.units
		"%"
	end

	def getNEWS
		case 
		when value <= 91
			3
		when value <= 93
			2
		when value <= 95
			1
		else 
			0
		end			
	end

	validates :value, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
end
