class Patient < ActiveRecord::Base
	belongs_to :ward
	has_many :observations, dependent: :destroy

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
			observations.inject([]) do |data, item|
				if item.sys_bp_measurement && item.dia_bp_measurement
					data.push({
						x: item.recorded_at.to_i*1000, 
						y: item.sys_bp_measurement.value,
						low: item.dia_bp_measurement.value
					}) 
				else
					data
				end
			end
		else		
			observations.inject([]) do |data, item|
				if eval("item.#{type}")
					data.push({
						x: item.recorded_at.to_i*1000, 
						y: eval("item.#{type}").value
					}) 
				else
					data
				end
			end
		end || []
		# Attempt to implement this at some point http://www.highcharts.com/demo/area-missing/gray
	end

	def getEWS
		observations.last.try{|o| o.getEWS} || {score: 0, complete: false, rating: 0}
	end
end
