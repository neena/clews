class Patient < ActiveRecord::Base
	has_many :pulse_measurements, :dependent => :destroy
	validates :mrn, :uniqueness => true
end
