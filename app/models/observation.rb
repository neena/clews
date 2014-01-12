class Observation < ActiveRecord::Base
	belongs_to :patient

	default_scope { order('recorded_at ASC') }

	@@measurement_types = ['pulse', 'oxygen_sat', 'oxygen_supp', 'sys_bp', 'dia_bp', 'respiration_rate', 'concious', 'temperature']
	def self.measurement_types 
		@@measurement_types
	end

	@@measurement_types.each do |m|
		has_one "#{m}_measurement".to_sym, :dependent => :destroy
		accepts_nested_attributes_for "#{m}_measurement".to_sym
	end

	validates :recorded_at, :uniqueness => true
	validates_presence_of :recorded_at, :patient_id

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

	def measurements
		@@measurement_types.inject({}) do |data, m|
			data[m.to_sym] = eval("#{m}_measurement")
			data
		end
	end
end
