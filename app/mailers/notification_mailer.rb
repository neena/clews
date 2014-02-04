class NotificationMailer < ActionMailer::Base
  
  default from: "from@example.com"
  default to: "user@nhs.com"
  
  def observation_email(patient, message, to)
    @patient = patient
    @message = message
    mail(subject: "Observation notification for patient #{patient.name}", to: to)
  end
end
