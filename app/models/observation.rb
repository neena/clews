class Observation < ActiveRecord::Base
	belongs_to :patient

	has_one :pulse_measurement, :dependent => :destroy
	has_one :oxygen_sat_measurement, :dependent => :destroy
	has_one :oxygen_supp_measurement, :dependent => :destroy
	has_one :temperature_measurement, :dependent => :destroy
	has_one :concious_measurement, :dependent => :destroy
	has_one :respiration_rate_measurement, :dependent => :destroy
	has_one :sys_bp_measurement, :dependent => :destroy
	has_one :dia_bp_measurement, :dependent => :destroy

	validates :recorded_at, :uniqueness => true
	validates_presence_of :recorded_at

	def getEWS
		output = {}

		#Calucalate Score
		data = [concious_measurement, sys_bp_measurement, pulse_measurement, oxygen_sat_measurement, oxygen_supp_measurement, respiration_rate_measurement, temperature_measurement]
		output[:score] = data.inject(0) do |sum, mes|
			mes ? sum + mes.getEWS : sum
		end

		#Calculate rating (scale from 0 to 3)
		output[:rating] = (0.318 + output[:score]*0.164 + 0.0431*output[:score]*output[:score] + -0.00291*output[:score]*output[:score]*output[:score]).round #Polynomial regression of scores to power of 3
		
		if output[:score] > 15 #Handle exceptions from regression line
			output[:rating] = 3
		elsif output[:rating] < 2 && data.any? {|datum| datum.try{|d| d.getEWS == 3}}
			output[:rating] = 2
		end
		
		#Check if data was complete
		output[:complete] = !data.any?{|datum| datum.blank?}
		
		#Return all output
		return output
	end
end
