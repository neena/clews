class Ward < ActiveRecord::Base
	has_many :patients

	serialize :emails, Array 

	validates_presence_of :name
end

