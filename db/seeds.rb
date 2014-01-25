# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Not perfect, works with EWSConfig but pretty hack-ily
require 'securerandom'

5.times do
  w = Ward.create(name: Faker::Lorem.word.titleize + " Ward")
  puts "Created ward: #{ w.name }"
end

10.times do |i|
  p = Patient.create(mrn: SecureRandom.uuid,
                     given_name: Faker::Name.first_name,
                     surname: Faker::Name.last_name,
                     ward: Ward.first(:order => "RANDOM()"))

  puts "Created patient: #{ p.name }"

  72.times do |i|
    p.observations.create(
      recorded_at: (DateTime.now - (i*4).hours),
      pulse_measurement: PulseMeasurement.create(value: rand(EWSConfig["Pulse"]["min2"]..EWSConfig["Pulse"]["max2"])),
      oxygen_sat_measurement: OxygenSatMeasurement.create(value: rand(EWSConfig["OxygenSat"]["min2"]..EWSConfig["OxygenSat"]["min0"])),
      oxygen_supp_measurement: OxygenSuppMeasurement.create(value: [true,false].sample),
      temperature_measurement: TemperatureMeasurement.create(value: rand(EWSConfig["Temperature"]["min2"]..EWSConfig["Temperature"]["max1"])),
      concious_measurement: ConciousMeasurement.create(value: ["A", "V", "P", "U"].sample),
      respiration_rate_measurement: RespirationRateMeasurement.create(value: rand(EWSConfig["RespirationRate"]["min2"]..EWSConfig["RespirationRate"]["max2"])),
      sys_bp_measurement: SysBpMeasurement.create(value: rand(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"])),
      dia_bp_measurement: DiaBpMeasurement.create(value: rand(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"]))
    )

    puts "- Creating observation #{i+1}"
  end
end
