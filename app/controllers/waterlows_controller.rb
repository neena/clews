class WaterlowsController < ApplicationController

	def new
		@waterlow = Waterlow.new
		@waterlow.patient = Patient.find_by_mrn(params[:mrn]) || nil
	end

	def create
		@patient = Patient.find(params[:observation][:patient_id])
		@waterlow = @patient.waterlows.new(observation_params.merge({recorded_at: DateTime.now}))
		if @waterlow.save
			redirect_to rounds_patients_path
		else
			render :new
		end
	end

	def update

	end

	private
		def observation_params 
			hash = Observation.measurement_types.inject({}) do |data, type|
				data["#{type}_measurement_attributes".to_sym] = [:value]
				data
			end
			params.require(:observation).permit(hash)
		end
end
