class Admin::GlanceController < AdminController
	def index
		@observations = Patient.all.inject([]) do |data, patient|
			data += patient.observations.incomplete
			data
		end
		authorize! :glance, Admin
	end
end
