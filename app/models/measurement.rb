class Measurement < ActiveRecord::Base
	self.abstract_class = true

	belongs_to :observation 
	validate :valid_value

	def self.units
		nil
	end

	def valid_value
		errors.add(:value, 'Measurement must have value') if !(value || value == false)
	end

	def getEWS
		if config = EWSConfig[self.class.name.sub("Measurement", "")]
			if value.is_a? Numeric
				[3,2,1].detect do |group| 
					config["max#{group-1}"].try {|bound| value >= bound} || config["min#{group-1}"].try {|bound| value <= bound} 
				end || 0
			else
				[3,2,1,0].detect do |group| 
					if config[group].is_a? Array
						config[group].any? {|val| val == value}
					else
						config[group].try {|val| val == value}
					end
				end || 0
			end
		else
			0
			# raise StandardError, "Could not load data for #{self.class.name} from YML file"
		end
	end

	def self.title 
		"#{human_name} #{"(#{units})" if units.present?}"
	end

	def self.human_name
		name.titleize[0..-12]
	end
end

