class AdminController < ApplicationController

	def glance
		@observations = Patient.all.inject([]) do |data, patient|
			patient.observations.each do |obs|
				data.push(obs) if obs.measurements.any? {|k,v| v.nil?}
			end
			data
		end
	end
end
