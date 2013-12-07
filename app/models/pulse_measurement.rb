class PulseMeasurement < ActiveRecord::Base
	belongs_to :patient 

	validates :datetime, :uniqueness => true
end
