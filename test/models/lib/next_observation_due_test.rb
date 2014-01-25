require 'test_helper'

class NextObservationDueTest < ActiveSupport::TestCase

  test '#calculate should add 12 hours to priority 0' do
    Delorean.time_travel_to(DateTime.parse('2014-01-01 00:00:00')) do
      due = NextObservationDue.calculate Time.now, 0
      assert_equal '2014-01-01 12:00:00', due.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  test '#calculate should add 6 hours to priority 1' do
    Delorean.time_travel_to(DateTime.parse('2014-01-01 00:00:00')) do
      due = NextObservationDue.calculate Time.now, 1
      assert_equal '2014-01-01 06:00:00', due.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  test '#calculate should add 1 hour to priority 2' do
    Delorean.time_travel_to(DateTime.parse('2014-01-01 00:00:00')) do
      due = NextObservationDue.calculate Time.now, 2
      assert_equal '2014-01-01 01:00:00', due.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  test '#calculate should add 1 minute to priority 3' do
    Delorean.time_travel_to(DateTime.parse('2014-01-01 00:00:00')) do
      due = NextObservationDue.calculate Time.now, 3
      assert_equal '2014-01-01 00:01:00', due.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  test '#calculate should return exception if number is negative' do
    assert_raise ArgumentError do
      NextObservationDue.calculate Time.now, -1
    end
  end

  test '#calculate should return exception if number is out of range' do
    assert_raise ArgumentError do
      NextObservationDue.calculate Time.now, 4
    end
  end
end

