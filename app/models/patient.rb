class Patient < ActiveRecord::Base
	validates :MRN, :uniqueness => true
end
