class NextObservationDue
  FREQUENCY = {
    '0' => [8.hours, 20.hours],
    '1' => [2.hours, 8.hours, 14.hours, 20.hours],
    '2' => (0..23).to_a.map(&:hours)
  }
  # Public: Calculates when next Observation is due by
  #
  # last_observed - DateTime of last Observation
  # rating        - Integer of rating for EWS
  #
  # Returns DateTime of next Observation
  def self.calculate(last_observed, rating)
    raise ArgumentError, 'Rating must be within range' if FREQUENCY[rating.to_s].nil?
    if rating == 3
      DateTime.now
    else
      FREQUENCY[rating.to_s].map{|h| DateTime.now.midnight + h}.find {|d| d > DateTime.now}
    end
  end
end
