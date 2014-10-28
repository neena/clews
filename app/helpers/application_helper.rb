module ApplicationHelper
  def humanise_consciousness(val)
    case val.downcase
    when 'a'
      'Alert'
    when 'p'
      'Pain'
    when 'v'
      'Voice'
    when 'u'
      'Unresponsive'
    else
      'N/R'
    end
  end

  def when_is(reminder)
    if Time.now > reminder.due
      time_ago_in_words(reminder.due) + " ago"
    else
      "in " + distance_of_time_in_words_to_now(reminder.due)
    end
  end

  def ReminderColor(reminder)
    darkness = Math::E**((Time.zone.now - reminder.due)/3000)
    darkness = 0.9 if darkness > 0.9
    darkness = 0 if darkness < 0.0001
    darkness
  end

  def actionPath(reminder)
    if reminder.reminder_type == "vital_signs"
      new_observation_url + "?mrn=" + reminder.patient.mrn
    else
      nil
    end
  end
end
