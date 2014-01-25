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
  
  test "should return the correct notification message" do
    assert_equal @patient.get_ews_message(0), "The minimum frequency of monitoring should be 12 hourly"
    assert_equal @patient.get_ews_message(1), "4–6 hourly with scores of 1–4, unless more or less frequent monitoring is considered appropriate"
    assert_equal @patient.get_ews_message(5), "We recommend that the frequency of monitoring should be increased to a minimum of hourly"
    assert_equal @patient.get_ews_message(7), "We recommend continuous monitoring and recording of vital signs for this patient"
  end
end
