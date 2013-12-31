module MeasurementHelper
	extend ActiveSupport::Concern
	
	#Instead of extending from base class, use module to apply standard settings
	included do
		belongs_to :patient 
		validates :datetime, :uniqueness => true
		validates_presence_of :datetime, :patient_id
		validate :valid_value

		def valid_value
			errors.add(:value, 'Measurement must have value') if !(value || value == false)
		end

		def getEWS
			# Not currently implemented as yml file lacks complete data.
			if value.is_a? Numeric
				[3,2,1].detect {|group| (EWSConfig[self.class.name]["max#{group-1}"] && value >= EWSConfig[self.class.name]["max#{group-1}"]) || (EWSConfig[self.class.name]["min#{group-1}"] && value <= EWSConfig[self.class.name]["min#{group-1}"])} || 0
			else
				getNEWS
			end
		end
	end
end