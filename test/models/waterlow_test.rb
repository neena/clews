require 'test_helper'

class WaterlowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @patient = Patient.create(surname: "Bloggs", given_name: "Joe", mrn: "D21001997")
    @waterlow_opts = {height: 1.50, weight: 76.0, patient: @patient, skin_type: "healthy", appetite: true}
  end
  
  test "should not save without appetite unless patient has lost weight" do
    @waterlow_opts[:appetite] = nil

    @waterlow_opts[:weight] = 77.0
    w = @patient.waterlows.build(@waterlow_opts)
    assert !w.save, "Saved the reading without appetite recording on first waterlow"
    w.appetite = true
    assert w.save, "Did not save the reading with appetite recording on first waterlow"
    assert_equal 2, w.nutrition_score

    x = @patient.waterlows.build(@waterlow_opts)
    assert !x.save, "Saved the reading without appetite recording even though patient has not lost weight"
    x.appetite = false
    assert x.save, "Did not save the reading with appetite recording on second waterlow"
    assert_equal 1, x.nutrition_score

    @waterlow_opts[:weight] = 76.0
    y = @patient.waterlows.build(@waterlow_opts)
    assert y.save, "Did not save the reading without appetite recording despite weight loss"
    assert_equal 1, y.nutrition_score
  end

  test "should return the correct skin_type_score" do
    @waterlow_opts[:skin_type] = "HEALTHY"
    assert_equal 0, @patient.waterlows.create(@waterlow_opts).skin_type_score

    @waterlow_opts[:skin_type] = "Dry"
    assert_equal 1, @patient.waterlows.create(@waterlow_opts).skin_type_score

    @waterlow_opts[:skin_type] = "discoloured grade 1"
    assert_equal 2, @patient.waterlows.create(@waterlow_opts).skin_type_score

    @waterlow_opts[:skin_type] = "bRokeN/SpOts GraDE 2"
    assert_equal 3, @patient.waterlows.create(@waterlow_opts).skin_type_score
  end
end
