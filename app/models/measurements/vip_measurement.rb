class VipMeasurement < Measurement
	validates :value, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 5}

	def self.options
		[["IV site appears healthy".html_safe, 0],
		["One of the following signs is evident:<br>- Slight pain near IV site OR<br>- Slight redness near IV site".html_safe, 1],
		["TWO of the following are evident:<br>- Pain at IV site<br>- Redness<br>- Swelling".html_safe, 2],
		["ALL of the following signs are evident:<br>- Pain along path of cannula<br>- Redness around site<br>- Swelling".html_safe, 3],
		["ALL of the following signs are evident and extensive:<br>- Pain along path of cannula<br>- Redness around site<br>- Swelling<br>- Palpable venous cord".html_safe, 4],
		["ALL of the following signs are evident and extensive:<br>- Pain along path of cannula<br>- Redness around site<br>- Swelling<br>- Palpable venous cord<br>- Pyrexia".html_safe, 5]]
	end

end
