require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  
  def setup 
    @patient = Patient.new
  end

  test "should return true if score is within a given range" do
    assert @patient.score_within(1, 1, 4)
    assert @patient.score_within(4, 1, 4)
  end
  
  test "should return false if score is outside range" do
    assert !@patient.score_within(0, 1, 4)
    assert !@patient.score_within(5, 1, 4)
  end
end
