class NextObservationDue
  FREQUENCY = {
    '0' => 12.hours,
    '1' => 6.hours,
    '2' => 1.hour,
    '3' => 1.minute
  }
  
  # Public: Calculates when next Observation is due by
  #
  # last_observed - DateTime of last Observation
  # rating        - Integer of rating for EWS
  #
  # Returns DateTime of next Observation
  def self.calculate(last_observed, rating)
    raise ArgumentError, 'Rating must be within range' if FREQUENCY[rating.to_s].nil?
    last_observed + FREQUENCY[rating.to_s]
  end
end
