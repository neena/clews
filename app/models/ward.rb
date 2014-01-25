class Ward < ActiveRecord::Base
	has_many :patients

	validates_presence_of :name
end

