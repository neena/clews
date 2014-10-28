class Observation < ActiveRecord::Base
  belongs_to :patient

  default_scope { order('recorded_at ASC') }
  scope :incomplete, lambda { where status: 'incomplete' }

  @@measurement_types = ['pulse', 'oxygen_sat', 'oxygen_supp', 'vip', 'sys_bp', 'dia_bp', 'respiration_rate', 'concious', 'temperature']

  # validates :recorded_at, :uniqueness => true
  validates_presence_of :recorded_at, :patient_id

  before_save :generate_ews
  after_save :patient_callbacks

  def measurements
    @@measurement_types.inject({}) do |data, m|
      data[m.to_sym] = eval(m)
      data
    end
  end

  def complete?
    status == 'complete'
  end

  def getEWS
    { score: score, rating: rating, complete: complete? }
  end

  def measurement type # Present measurement data in wrapper of object
    "#{type}_measurement".classify.constantize.new(eval(type))
  end

  def getVIP
    vip
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
    case !incomplete_data?
    when true
      self.status = 'complete'
    else
      self.status = 'incomplete'
    end
  end

  def measurement_data
    EWSConfig.keys.inject([]) do |data, m|
      data.push(measurement(m.underscore))
      data
    end
  end

  def sum_measurement_scores(measurements)
    measurements.inject(0) do |sum, measurement|
      measurement ? sum + measurement.getEWS : sum
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

  def incomplete_data?
    measurements.values.any?(&:nil?)
  end

  def patient_callbacks
    self.patient.update_observation_due_at(self)
  end
end
