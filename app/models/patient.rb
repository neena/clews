class Patient < ActiveRecord::Base
  belongs_to :ward
  has_many :observations,
            dependent: :destroy,
            after_add: [:check_threshold!]
  has_many :waterlows, dependent: :destroy
  has_many :reminders, dependent: :destroy

  validates :mrn, :uniqueness => true
  validates_inclusion_of :sex, :in => ["m", "f", nil]

  default_scope { order(:surname) }

  scope :no_observation, lambda { where(['observation_due_at IS NULL']) }
  scope :due_observation, lambda { |h| where(['observation_due_at < ?', Time.zone.now + h.hours]).order('observation_due_at ASC') }

  def name
    if surname && given_name
      "#{surname}, #{given_name}"
    elsif surname || given_name
      surname || given_name
    else
      nil
    end
  end

  def age
    if dob
      now = Time.now.utc.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    else
      0
    end
  end

  def to_param
    mrn
  end

  # Public: Returns just the relevant Observation
  #
  # Returns one Observation
  def latest_observations
    observations.limit(10)
  end

  def getData type #in HighCharts ready format.
    if type == 'bp'
      observations.inject([]) do |data, item|
        if item.sys_bp && item.dia_bp
          data.push({
            x: item.recorded_at.to_i*1000,
            y: item.sys_bp,
            low: item.dia_bp,
            ews: item.measurement('sys_bp').getEWS
          })
        else
          data
        end
      end
    else
      observations.inject([]) do |data, item|
        data.push({
          x: item.recorded_at.to_i*1000,
          y: eval("item.#{type}")
        })
      end
    end || []
  end

  def getEWS
    observations.last.try{|o| o.getEWS} || {score: 0, complete: false, rating: 0}
  end

  def getVIP
    observations.last.getVIP
  end

  ## Patient notifications

  MESSAGES = {
    minimum: "The minimum frequency of monitoring should be 12 hourly",
    standard: "4-6 hourly with scores of 1-4, unless more or less frequent monitoring is considered appropriate",
    frequent: "We recommend that the frequency of monitoring should be increased to a minimum of hourly",
    continuous: "We recommend continuous monitoring and recording of vital signs for this patient"
  }

  def score_within(n, lower_bound, upper_bound)
    n >= lower_bound && n <= upper_bound
  end

  def get_ews_message(rating)
    case rating
    when 0
      MESSAGES[:minimum]
    when 1
      MESSAGES[:standard]
    when 2
      MESSAGES[:frequent]
    when 3
      MESSAGES[:continuous]
    end
  end

  # If the patient EWS score is above 5 send the { ward manager ?? } an email
  def check_threshold!(observation)
    ews_rating = getEWS[:rating]
    message   = get_ews_message(ews_rating)
    if ews_rating > 1
      ward.emails.each do |email|
        NotificationMailer.observation_email(self, message, ward.email).deliver
      end
    end
  end


  def update_observation_due_at(observation)
    if observation.recorded_at.to_i >= observations.last.recorded_at.to_i
      next_observation = NextObservationDue.calculate(observation.recorded_at, observation.rating)
      self.update_attribute(:observation_due_at, next_observation)
      Reminder.create(due: next_observation, patient: self, title: "Vital signs observations", reminder_type: "vital_signs")
    end
  end
end
