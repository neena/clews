module MeasurementHelper
	extend ActiveSupport::Concern
	
	included do
		belongs_to :patient 
		validates :datetime, :uniqueness => true
		validates_presence_of :datetime, :patient_id
		validate :valid_value

		def valid_value
			errors.add(:value, 'Measurement must have value') if !(value || value == false)
		end
	end
end