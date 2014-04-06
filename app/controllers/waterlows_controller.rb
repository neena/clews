class WaterlowsController < ApplicationController

	def new
		@patient = Patient.find_by_mrn(params[:mrn]) || Patient.find_by_id(params[:patient_id]) || nil
		@waterlow = @patient.try(&:waterlows).try(&:last).try(&:dup) || Waterlow.new(patient: @patient)
	end

	def create
		@waterlow = Waterlow.new(params.require(:waterlow).permit(:patient_id, :height, :weight, :skin_type, :mobility, :continence, :appetite))
		@waterlow.special_risks = params[:waterlow][:special_risks].reject(&:empty?).map{|i| eval(i)}.reduce(:merge)
		if @waterlow.save
			redirect_to rounds_patients_path, notice: "Successfully saved Waterlow for #{Patient.find(params[:patient_id]).name}"
		else
			render :new, alert: "Invalid Waterlow. Please check you've filled this out correctly. "
		end
	end

	def update
		
	end
end
