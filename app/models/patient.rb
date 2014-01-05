class Patient < ActiveRecord::Base
	has_many :observations, dependent: :destroy

	has_many :pulse_measurements, dependent: :destroy, through: :observations
	has_many :oxygen_sat_measurements, dependent: :destroy, through: :observations
	has_many :oxygen_supp_measurements, dependent: :destroy, through: :observations
	has_many :temperature_measurements, dependent: :destroy, through: :observations
	has_many :concious_measurements, dependent: :destroy, through: :observations
	has_many :respiration_rate_measurements, dependent: :destroy, through: :observations
	has_many :sys_bp_measurements, dependent: :destroy, through: :observations
	has_many :dia_bp_measurements, dependent: :destroy, through: :observations

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
		type.chop! if type[-1,1] == "s"
		if type == 'bp_measurement'
			observations.sort_by{|o| o.recorded_at}.inject([]) do |data, item|
				data.push({
					x: item.recorded_at.to_i*1000, 
					y: item.sys_bp_measurement.value,
					low: item.dia_bp_measurement.value
				}) if item.sys_bp_measurement && item.dia_bp_measurement
			end
		else		
			observations.sort_by{|o| o.recorded_at}.inject([]) do |data, item|
				data.push({
					x: item.recorded_at.to_i*1000, 
					y: eval("item.#{type}").value,
				}) if eval("item.#{type}")
			end
		end || []
	end

	def getLatest type #Deprecate once view is clean. 
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
		observations.last.try{|o| o.getEWS} || {score: 0, complete: false, rating: 0}
	end
end
