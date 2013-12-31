class PatientsController < ApplicationController
  include ChartHelper

  def index
    @ward = params[:ward]
    @filter = Patient.select(:ward).distinct.select{|p| p.ward?}.collect{|p| ["Ward #{p.ward}", p.ward]}.unshift(["All Wards", "all"])
    
    if @ward && @ward != "all"
      @patients = Patient.where(ward: params[:ward])
    else
    	@patients = Patient.all
    end
  end

  def show
  	@patient = Patient.find_by_mrn(params[:id]) || Patient.find(params[:id])

    #Create charts
  	@pulse_chart = createChart('Pulse', 'bpm', 'pulse')
  	@oxygen_chart = createChart('Oxygen', '%', 'oxygen sat')
    @temperature_chart = createChart('Temperature', "\u00B0c", 'temperature')
    @respiration_rate_chart = createChart('Respiratory Rate', "/mins", 'respiration rate')
    @bp_chart = createChart('Blood Presure', 'mmHg', 'bp')
  end
end
