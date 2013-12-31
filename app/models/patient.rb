class Patient < ActiveRecord::Base
	has_many :pulse_measurements, :dependent => :destroy
	has_many :oxygen_sat_measurements, :dependent => :destroy
	has_many :oxygen_supp_measurements, :dependent => :destroy
	has_many :temperature_measurements, :dependent => :destroy
	has_many :concious_measurements, :dependent => :destroy
	has_many :respiration_rate_measurements, :dependent => :destroy
	has_many :sys_bp_measurements, :dependent => :destroy
	has_many :dia_bp_measurements, :dependent => :destroy

	validates :mrn, :uniqueness => true

	def name 
		if surname && given_name
			"#{surname}, #{given_name}"
		elsif surname || given_name
			surname || given_name
		else 
			nil
		end
	end

	def to_param
		mrn
	end

	def getData type #in HighCharts ready format. 
		if type == 'bp_measurements'
			sys_bp_measurements.inject([]) do |data, item|
				data.push({
					x: item.datetime.to_i*1000, 
					y: item.value,
					low: dia_bp_measurements.where(datetime: item.datetime.advance(:minutes => -1)..item.datetime.advance(:minutes => +1)).first.value
				})
			end
		else
			eval(type).inject([]) {|data, item| data.push([item.datetime.to_i*1000, item.value])}
		end
	end

	def getLatest type #maybe move logic to a view helper? 
		if eval(type).last
			if eval(type).last.value == true
				'yes'
			elsif eval(type).last.value == false
				'no'
			else
				eval(type).last.value
			end
		else
			nil
		end
	end

	def getEWS
		output = {}

		#Calucalate Score
		data = [concious_measurements, sys_bp_measurements, pulse_measurements, oxygen_sat_measurements, oxygen_supp_measurements, respiration_rate_measurements, temperature_measurements].map{|set| set.last}
		output[:score] = data.inject(0) do |sum, mes|
			sum += mes.getNEWS if mes
			sum
		end

		#Calculate rating (scale from 0 to 3)
		output[:rating] = (0.318 + output[:score]*0.164 + 0.0431*output[:score]*output[:score] + -0.00291*output[:score]*output[:score]*output[:score]).round #Polynomial regression of scores to power of 3
		
		if output[:score] > 15 #Handle exceptions from regression line
			output[:rating] = 3
		elsif output[:rating] < 2 && data.any? {|datum| !datum.blank? && datum.getNEWS == 3}
			output[:rating] = 2
		end
		
		#Check if data was complete
		output[:complete] = !data.any?{|datum| datum.blank?}
		
		#Return all output
		return output
	end
end
