# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Not perfect, works with EWSConfig but pretty hack-ily

Patient.all.each do |patient|
	if patient.observations.blank?
		18.times do |i|
			puts "Creating observation #{i} for #{patient.name}"
			o = Observation.create(patient: patient, recorded_at: (DateTime.now - (i*4).hours))
			o.pulse_measurement = PulseMeasurement.create(value: rand(EWSConfig["Pulse"]["min2"]..EWSConfig["Pulse"]["max2"]))
			o.oxygen_sat_measurement = OxygenSatMeasurement.create(value: rand(EWSConfig["OxygenSat"]["min2"]..EWSConfig["OxygenSat"]["min0"]))
			o.oxygen_supp_measurement = OxygenSuppMeasurement.create(value: [true,false].sample)
			o.temperature_measurement = TemperatureMeasurement.create(value: rand(EWSConfig["Temperature"]["min2"]..EWSConfig["Temperature"]["max1"]))
			o.concious_measurement = ConciousMeasurement.create(value: ["A", "V", "P", "U"].sample)
			o.respiration_rate_measurement = RespirationRateMeasurement.create(value: rand(EWSConfig["RespirationRate"]["min2"]..EWSConfig["RespirationRate"]["max2"]))
			o.sys_bp_measurement = SysBpMeasurement.create(value: rand(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"]))
			o.dia_bp_measurement = DiaBpMeasurement.create(value: rand(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"]))
		end
	end 
end