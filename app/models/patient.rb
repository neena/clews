class Patient < ActiveRecord::Base
	belongs_to :ward
	has_many :observations, dependent: :destroy
	
	before_save :check_threshold!

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
	
	## Patient notifications
	
	MESSAGES = {
    minimum: "the minimum frequency of monitoring should be 12 hourly",
    standard: "4–6 hourly with scores of 1–4, unless more or less frequent monitoring is considered appropriate",
    frequent: "We recommend that the frequency of monitoring should be increased to a minimum of hourly",
    continuous: "We recommend continuous monitoring and recording of vital signs for this patient"
	}

	def score_within(n, lower_bound, upper_bound)
	  n >= lower_bound && n <= upper_bound
  end
	
	def get_ews_message(score)
	  if score == 0
	    MESSAGES[:minimum]
	  elsif score_within(score, 1,4)
      MESSAGES[:standard]
    elsif score_within(score, 5,6)
      MESSAGES[:frequent]
    else
      MESSAGES[:continuous]
    end
	end
	
	# If the patient EWS score is above a preset 
	# level then send a notification
	def check_threshold!
		ews_score = getEWS[:score]
		message   = get_ews_message(ews_score)
		NotificationMailer.observation_email(self, message).deliver
	end
end
