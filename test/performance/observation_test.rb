require 'test_helper'
require 'rails/performance_test_help'

class ObservationTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

	Admin.create email: 'admin@example.com', password: 'password'

	5.times do
	  w = Ward.create(name: "X Ward")
	end

	ward_ids = Ward.all.map(&:id)

	30.times do |i|
	  p = Patient.create(mrn: "D#{rand(1000000..9999999)}",
	                     given_name: "Name",
	                     surname: "Surname",
	                     ward: Ward.find(ward_ids.sample),
	                     mrsa_carrier: [true, false, nil].sample)

	  72.times do |i|
	    p.observations.create(
	      recorded_at: (DateTime.now - (i*4).hours),
	      pulse: rand(EWSConfig["Pulse"]["min2"]..EWSConfig["Pulse"]["max2"]),
	      oxygen_sat: rand(EWSConfig["OxygenSat"]["min2"]..EWSConfig["OxygenSat"]["min0"]),
	      oxygen_supp: [true,false].sample,
	      temperature: rand(EWSConfig["Temperature"]["min2"]..EWSConfig["Temperature"]["max1"]),
	      concious: ["A", "V", "P", "U"].sample,
	      respiration_rate: rand(EWSConfig["RespirationRate"]["min2"]..EWSConfig["RespirationRate"]["max2"]),
	      sys_bp: rand(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"]),
	      dia_bp: rand(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"])/2,
	      vip: rand(0..5)
	    )
	  end
	end

	test "patient_chart_pages" do
		Patient.all.each do |p|
			get "/patients/#{p.mrn}"
		end
	end
end
