require 'test_helper'

class WaterlowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save without appetite unless patient has lost weight" do
  	@patient = Patient.create(surname: "Bloggs", given_name: "Joe", mrn: "D21001997")

  	@w = @patient.waterlows.build(height: 1.50, weight: 77.0)
  	assert !@w.save, "Saved the reading without appetite recording on first waterlow"
  	@w.appetite = false
  	assert @w.save, "Did not save the reading with appetite recording on first waterlow"
  	@w.save

  	@x = @patient.waterlows.build(height: 1.50, weight: 77.0, patient: @patient)
  	assert !@x.save, "Saved the reading without appetite recording even though patient has not lost weight"
  	@x.appetite = false
  	assert @x.save, "Did not save the reading with appetite recording on second waterlow"
  	@x.save

  	@y = @patient.waterlows.build(height: 1.50, weight: 76.0, patient: @patient)
  	p @patient.waterlows
  	puts "Weight loss: #{@x.weight_lost(76).inspect}"
  	assert @y.save, "Did not save the reading without appetite recording despite weight loss"
  end
end
