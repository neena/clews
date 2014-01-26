class NotificationMailer < ActionMailer::Base
  
  default from: "from@example.com"
  default to: "user@nhs.com"
  
  def observation_email(patient, message)
    @patient = patient
    mail(subject: "Observation notification for patient #{patient.name}")
  end
end
