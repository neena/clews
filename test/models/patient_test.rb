require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  
  setup do 
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
    assert_equal @patient.get_ews_message(1), "4-6 hourly with scores of 1-4, unless more or less frequent monitoring is considered appropriate"
    assert_equal @patient.get_ews_message(2), "We recommend that the frequency of monitoring should be increased to a minimum of hourly"
    assert_equal @patient.get_ews_message(3), "We recommend continuous monitoring and recording of vital signs for this patient"
  end


  test '#latest_observations should return 10 observations' do
    @patient = Patient.create(mrn: SecureRandom.uuid)
    Observation.any_instance.stubs(:rating).returns(0)
    Observation.any_instance.stubs(:recorded_at).returns(Time.zone.now)
    11.times { @patient.observations.create }
  end

  test 'updates next observation date after adding an observation' do
    @patient = Patient.create(mrn: SecureRandom.uuid)
    Observation.any_instance.stubs(:rating).returns(0)

    Delorean.time_travel_to(Time.zone.parse('2014-01-01 00:00:00 UTC +00:00')) do
      @patient.observations.create(recorded_at: Time.zone.now)

      observation = @patient.observations.last
      expected = NextObservationDue.calculate(observation.recorded_at, observation.rating)

      # Shit test, dunno how to get the dates to compare properly
      # See: http://stackoverflow.com/questions/12811207/comparison-of-date-with-activesupporttimewithzone-failed
      assert_equal expected.to_s, @patient.observation_due_at.to_s
    end

  end

end
