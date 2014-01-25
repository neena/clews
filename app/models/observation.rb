class Observation < ActiveRecord::Base
	belongs_to :patient

	default_scope { order('recorded_at ASC') }

	@@measurement_types = ['pulse', 'oxygen_sat', 'oxygen_supp', 'sys_bp', 'dia_bp', 'respiration_rate', 'concious', 'temperature']

	@@measurement_types.each do |m|
		has_one "#{m}_measurement".to_sym, :dependent => :destroy
		accepts_nested_attributes_for "#{m}_measurement".to_sym
	end

	validates :recorded_at, :uniqueness => true
	validates_presence_of :recorded_at, :patient_id

	before_save :generate_ews

	def measurements
		@@measurement_types.inject({}) do |data, m|
			data[m.to_sym] = eval("#{m}_measurement")
			data
		end
	end

	def complete?
		status == 'complete'
	end

	def getEWS
		{ score: score, rating: rating, complete: complete? }
	end

	def self.measurement_types
		@@measurement_types
	end

	private

	def generate_ews
		#Calucalate Score
		data = [concious_measurement, sys_bp_measurement, pulse_measurement, oxygen_sat_measurement, oxygen_supp_measurement, respiration_rate_measurement, temperature_measurement]
		score = data.inject(0) do |sum, mes|
			mes ? sum + mes.getEWS : sum
		end

		#Calculate rating (scale from 0 to 3)
		rating = (0.318 + score*0.164 + 0.0431*score*score  -0.00291*score*score*score).round #Polynomial regression of scores to power of 3

		if score > 15 #Handle exceptions from regression line
			rating = 3
		elsif rating < 2 && data.any? {|datum| datum.try{|d| d.getEWS == 3}}
			rating = 2
		end

		#Check if data was complete
		case !data.any?{|datum| datum.blank?}
		when true
			status = 'complete'
		else
			status = 'incomplete'
		end
	end
end
