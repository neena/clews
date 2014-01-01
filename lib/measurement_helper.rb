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
			config = EWSConfig[self.class.name.slice("Measurement")]
			# Not currently implemented as yml file lacks complete data.
			if value.is_a? Numeric
				[3,2,1].detect do |group| 
					config["max#{group-1}"].try {|bound| value >= bound} || config["min#{group-1}".try {|bound| value <= bound} 
				end || 0
			else
				[3,2,1,0].detect do |group| 
					begin
						config[group].any? {|val| val == value}
					rescue NoMethodError
						config[group].try {|val| val == value}
					end
				end
			end
		end
	end
end