module MeasurementHelper
	extend ActiveSupport::Concern
	
	included do
		belongs_to :patient 
		validates :datetime, :uniqueness => true
	end
end