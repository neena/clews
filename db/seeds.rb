# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Not perfect, works with EWSConfig but pretty hack-ily

require 'securerandom'

Admin.create email: 'admin@example.com', password: 'password'

5.times do
  w = Ward.create(name: Faker::Lorem.word.titleize + " Ward")
  puts "Created ward: #{ w.name }"
end

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
