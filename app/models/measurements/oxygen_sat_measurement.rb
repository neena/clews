class OxygenSatMeasurement < Measurement

	def self.units
		"%"
	end

	def self.human_name 
		"Oxygen Saturation"
	end

	validates :value, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
end
