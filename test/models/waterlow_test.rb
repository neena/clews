require 'test_helper'

class WaterlowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @patient = Patient.create(surname: "Bloggs", given_name: "Joe", mrn: "D21001997", dob: DateTime.new(1967,3,27), sex: "m")
    @waterlow_opts = {height: 1.70, weight: 66.0, patient: @patient, skin_type: "healthy", appetite: true} #Will return score of 4 on first reading, 2 on second onwards
  end
  
  test "overall scores sum correctly" do
    assert_equal 4, @patient.waterlows.create(@waterlow_opts).score
    assert_equal 2, @patient.waterlows.create(@waterlow_opts).score
  end

  test "should not save without appetite unless patient has lost weight and return correct nutrition_score" do
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
    assert_equal 0, @patient.waterlows.create(@waterlow_opts).send(:skin_type_score)

    @waterlow_opts[:skin_type] = "Dry"
    assert_equal 1, @patient.waterlows.create(@waterlow_opts).send(:skin_type_score)

    @waterlow_opts[:skin_type] = "discoloured- grade 1 pressure ulcer"
    assert_equal 2, @patient.waterlows.create(@waterlow_opts).send(:skin_type_score)

    @waterlow_opts[:skin_type] = "bRokeN/SpOt- GraDE 2-4 pressure ULCER"
    assert_equal 3, @patient.waterlows.create(@waterlow_opts).send(:skin_type_score)
  end

  test "should return correct sex/age scores" do 
    waterlow = @patient.waterlows.create(@waterlow_opts)
    assert_equal 1, waterlow.send(:sex_score, "m")
    assert_equal 2, waterlow.send(:sex_score, "F")
    assert_equal nil, waterlow.send(:sex_score, "Q")

    assert_equal 1, waterlow.send(:age_score, 17)
    assert_equal 2, waterlow.send(:age_score, 50)
    assert_equal 5, waterlow.send(:age_score, 81)
  end

  test "should strip whitespace and downcase string fields" do
    @waterlow_opts[:skin_type] = "   HEALTHY    "
    waterlow = @patient.waterlows.create(@waterlow_opts)
    assert_equal "healthy", waterlow.skin_type

    waterlow.special_risks = {" SMOKING \n" => 1}
    waterlow.save
    assert_equal "smoking", waterlow.special_risks.keys.last
  end
end
