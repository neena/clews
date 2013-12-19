class Patient < ActiveRecord::Base
	has_many :pulse_measurements, :dependent => :destroy
	has_many :oxygen_sat_measurements, :dependent => :destroy
	has_many :oxygen_supp_measurements, :dependent => :destroy
	has_many :temperature_measurements, :dependent => :destroy

	validates :mrn, :uniqueness => true

	def name 
		"#{surname}, #{given_name}"
	end

	def getData type
		eval(type).inject([]) {|data, item| data.push([item.datetime.to_i*1000, item.value])}
	end

	def earlyWarningScore
		[pulse_measurements, oxygen_sat_measurements, temperature_measurements].inject(0) do |sum, mes|
			sum += mes.last.getNEWS if mes.last
			sum
		end
	end
end
