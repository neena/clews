# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Not perfect, works with EWSConfig but pretty hack-ily

require 'securerandom'
require_relative './mock_values'

Admin.create email: 'admin@example.com', password: 'password'

5.times do
  w = Ward.create(name: Faker::Lorem.word.titleize + " Ward")
  puts "= Created ward: #{ w.name }"
end

50.times do |i|
  p = Patient.create(mrn: SecureRandom.uuid,
                     given_name: Faker::Name.first_name,
                     surname: Faker::Name.last_name,
                     ward: Ward.first(:order => "RANDOM()"))

  puts "= Created patient: #{ p.name }"

  72.times do |i|
    p.observations.create(
      recorded_at:                  (Time.zone.now - (i*4).hours),
      pulse_measurement:            PulseMeasurement.create(value: pulse_value),
      oxygen_sat_measurement:       OxygenSatMeasurement.create(value: oxygen_sat_value),
      oxygen_supp_measurement:      OxygenSuppMeasurement.create(value: oxygen_supp_value),
      temperature_measurement:      TemperatureMeasurement.create(value: temperature_value),
      concious_measurement:         ConciousMeasurement.create(value: concious_value),
      respiration_rate_measurement: RespirationRateMeasurement.create(value: respiration_rate_value),
      sys_bp_measurement:           SysBpMeasurement.create(value: sys_bp_value),
      dia_bp_measurement:           DiaBpMeasurement.create(value: dia_bp_value)
    )

    puts "- Creating historic observation #{i+1}"
  end

  p.observations.create(
    recorded_at:                  (Time.zone.now),
    pulse_measurement:            PulseMeasurement.create(value: pulse_value),
    oxygen_sat_measurement:       OxygenSatMeasurement.create(value: oxygen_sat_value),
    oxygen_supp_measurement:      OxygenSuppMeasurement.create(value: oxygen_supp_value),
    temperature_measurement:      TemperatureMeasurement.create(value: temperature_value),
    concious_measurement:         ConciousMeasurement.create(value: concious_value),
    respiration_rate_measurement: RespirationRateMeasurement.create(value: respiration_rate_value),
    sys_bp_measurement:           SysBpMeasurement.create(value: sys_bp_value),
    dia_bp_measurement:           DiaBpMeasurement.create(value: dia_bp_value)
  )

  puts "- Creating current observation"

  reset_values
end
