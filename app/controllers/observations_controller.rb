class ObservationsController < ApplicationController

	def new
		@observation = Observation.new
		# Observation.where(recorded_at: (DateTime.now - 5.minutes)..DateTime.now).select {|o| o.measurements.any?{|k,v| v.nil?} }.last || Observation.new
		Observation.measurement_types.each do |type|
			eval("@observation.build_#{type}_measurement") unless eval("@observation.#{type}_measurement")
		end
	end

	def create
		@observation = Observation.new(observation_params )
		@observation.recorded_at = DateTime.now
		if @observation.save
			redirect_to @observation.patient
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
			params.require(:observation).permit(:patient_id, hash)
		end
end
