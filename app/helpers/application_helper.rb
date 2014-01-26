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
end
