class ObservationsController < ApplicationController

	def new
		@observation = Observation.where(recorded_at: (DateTime.now - 5.minutes)..DateTime.now).select {|o| o.measurements.any?{|k,v| v.nil?} }.last || Observation.new
		Observation.measurement_types.each do |type|
			eval("@observation.build_#{type}_measurement") unless eval("@observation.#{type}_measurement")
		end
	end

	def create

	end

	def update

	end
end
