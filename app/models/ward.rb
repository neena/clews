class Ward < ActiveRecord::Base
	has_many :patients

	serialize :emails, Array 

	validates_presence_of :name
	validate :valid_emails

	def email_addresses
		emails.join(", ") unless emails.blank?
	end

	def email_addresses=(values)
		self.emails = values.split(',').each(&:strip!)
	end

	private
	def valid_emails
		emails.each do |email|
			unless email =~ Devise::email_regexp
				errors.add(:emails, "Invalid email address added!")
			end 
		end
	end
end

