class Patient < ActiveRecord::Base
	has_many :pulse_measurements
	validates :MRN, :uniqueness => true
end
