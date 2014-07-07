# uses ENV variables
# To use, write a command like so
# rake db:seed all=true or rake db:seed patients=true wards=true 

if ENV['all'] == 'true'
  load_patients, load_wards, load_waterlows, load_reminders = true
else
  load_patients, load_wards, load_waterlows, load_reminders = [ENV['patients'], ENV['wards'], ENV['waterlows'], ENV['reminders']].map(&:present?)
end

require 'securerandom'

Admin.create email: 'admin@example.com', password: 'password' unless Admin.all.count > 0
if load_wards
  5.times do
    w = Ward.create(name: Faker::Lorem.word.titleize + " Ward")
    puts "Created ward: #{ w.name }"
  end
end

if load_patients
  30.times do |i|
    p = Patient.create(mrn: "D#{Faker::Number.number(9)}",
                       given_name: Faker::Name.first_name,
                       surname: Faker::Name.last_name,
                       ward: Ward.first(:order => "RANDOM()"),
                       mrsa_carrier: [true, false, nil].sample)

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
        dia_bp_measurement: DiaBpMeasurement.create(value: SysBpMeasurement.last.value*rand(0.7..0.85)),
        vip_measurement: VipMeasurement.create(value: rand(0..5))
      )
    end
  end
end

if load_reminders
  patient_ids = Patient.all.map(&:id)
  20.times do
    Reminder.create(patient: Patient.find(patient_ids.sample),
                    title: Faker::Lorem.sentence,
                    text: Faker::Lorem.paragraph,
                    due: (DateTime.now + ((rand(0..60)/6).hours)))
  end
end
