class GlanceController < ApplicationController

	def index
		@observations = Patient.all.inject([]) do |data, patient|
			patient.observations.each do |obs|
				data.push(obs) if obs.measurements.any? {|k,v| v.nil?}
			end
			data
		end
	end
end
