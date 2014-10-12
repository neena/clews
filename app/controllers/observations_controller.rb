class ObservationsController < ApplicationController

	def new
		@observation = Observation.new
		@observation.patient = Patient.find_by_mrn(params[:mrn]) || Patient.find_by_id(params[:patient_id])  || nil

		# Set defaults
		@observation.oxygen_supp = false
	end

	def create
		if !params[:observation][:patient_id].blank?
			@patient = Patient.find(params[:observation][:patient_id])
			@observation = @patient.observations.new(observation_params.merge({recorded_at: DateTime.now}))
			if @observation.save
				redirect_to reminders_path, notice: "Successfully saved observation for #{@patient.name}."
			else
				render :new, alert: "Observation invalid. Please check you've filled everything out correctly."
			end
		else
			@observation = Observation.new(observation_params.merge({recorded_at: DateTime.now}))
			render :new, alert: "Please select a patient."
		end

	end

	private
		def observation_params
			params.require(:observation).permit(Observation.measurement_types.map(&:to_sym))
		end
end
