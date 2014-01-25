require 'test_helper'

class PatientTest < ActiveSupport::TestCase

  setup do
    @patient = Patient.create(mrn: SecureRandom.uuid)
    Observation.any_instance.stubs(:rating).returns(0)
  end

  test 'updates next observation date after adding an observation' do
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
