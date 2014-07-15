class RemindersController < ApplicationController
  include ActionView::Helpers::DateHelper

	def index
		@ward = params[:ward] || cookies[:ward]
		cookies.delete :ward
		cookies.permanent[:ward] = @ward || "all"

		@ward_filter = Ward.all.sort_by{|p| p.name}.collect{|p| [p.name, p.id]}.unshift(["All Wards", "all"])

    @time = params[:time] || cookies[:time]
    cookies.delete :time
    cookies.permanent[:time] = @time || "all"

    @time_filter = [10, 30, 60, 120, 300, 720, 1440].map{|t| [time_ago_in_words(t.minutes.ago), t]}

    if @ward && @ward != "all"
			@reminders = Ward.find(@ward).reminders.ordered
		else
			@reminders = Reminder.all.ordered
		end

    @reminders = @reminders.select{|r| (r.due - Time.now) < @time.to_i.minutes}
	end

  def complete
    @reminder = Reminder.find(params[:id])
    @reminder.done = true
    @reminder.save

    redirect_to reminders_url
  end

  def new 
    @reminder = Reminder.new(due: (Time.now + 4.hours)) # Defaults go here
    @reminder.patient = Patient.find_by_mrn(params[:mrn]) || Patient.find_by_id(params[:patient_id])  || nil
  end

  def create
    @reminder = Reminder.new(params.require(:reminder).permit(:title, :patient_id, :text, :due))
  end
end
