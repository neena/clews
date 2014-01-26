class Observation < ActiveRecord::Base
  belongs_to :patient

  default_scope { order('recorded_at ASC') }
  scope :incomplete, lambda { where status: 'incomplete' }

  @@measurement_types = ['pulse', 'oxygen_sat', 'oxygen_supp', 'sys_bp', 'dia_bp', 'respiration_rate', 'concious', 'temperature']

  @@measurement_types.each do |m|
    has_one "#{m}_measurement".to_sym, :dependent => :destroy
    accepts_nested_attributes_for "#{m}_measurement".to_sym
  end

  # validates :recorded_at, :uniqueness => true
  validates_presence_of :recorded_at, :patient_id

  before_save :generate_ews

  def measurements
    @@measurement_types.inject({}) do |data, m|
      data[m.to_sym] = eval("#{m}_measurement")
      data
    end
  end

  def complete?
    status == 'complete'
  end

  def getEWS
    { score: score, rating: rating, complete: complete? }
  end

  def self.measurement_types
    @@measurement_types
  end

  private

  def generate_ews
    #Calucalate Score
    self.score = sum_measurement_scores(measurement_data)

    #Calculate rating (scale from 0 to 3)
    self.rating = calculate_rating(self.score, measurement_data)

    #Check if data was complete
    case !incomplete_data?(measurement_data)
    when true
      self.status = 'complete'
    else
      self.status = 'incomplete'
    end
  end

  def measurement_data
    [concious_measurement,
     sys_bp_measurement,
     pulse_measurement,
     oxygen_sat_measurement,
     oxygen_supp_measurement,
     respiration_rate_measurement,
     temperature_measurement]
  end

  def sum_measurement_scores(measurements)
    measurements.inject(0) do |sum, mesurement|
      mesurement ? sum + mesurement.getEWS : sum
    end
  end

  def calculate_rating(score, measurements)
    rating = 0

    case
    when score == 0
      rating = 0
    when score <= 4
      rating = 1
    when score <= 6
      rating = 2
    when score >= 7
      rating = 3
    end

     # Handle exception
    if rating < 2 && measurements.any? {|measurement| measurement.try{ |m| m.getEWS == 3} }
       rating = 2
    end

    return rating
  end

  def incomplete_data?(measurements)
    measurements.any?(&:nil?)
  end
end
