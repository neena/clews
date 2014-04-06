class ObservationsController < ApplicationController

	def new
		@observation = Observation.new
		@observation.patient = Patient.find_by_mrn(params[:mrn]) || Patient.find_by_id(params[:patient_id])  || nil
		# Observation.where(recorded_at: (DateTime.now - 5.minutes)..DateTime.now).select {|o| o.measurements.any?{|k,v| v.nil?} }.last || Observation.new
		Observation.measurement_types.each do |type|
			eval("@observation.build_#{type}_measurement") #unless eval("@observation.#{type}_measurement")
		end
	end

	def create
		@patient = Patient.find(params[:observation][:patient_id])
		@observation = @patient.observations.new(observation_params.merge({recorded_at: DateTime.now}))
		if @observation.save
			redirect_to rounds_patients_path, notice: "Successfully saved observation for #{@patient.name}."
		else
			render :new, alert: "Observation invalid. Please check you've filled everything out correctly."
		end
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
