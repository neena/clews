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
end
