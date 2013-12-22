class PatientsController < ApplicationController
  include ChartHelper

  def index
  	@patients = Patient.all
  end

  def show
  	@patient = Patient.find(params[:id])
  	@pulse_chart = createChart('Pulse', 'bpm', @patient.getData('pulse_measurements'), 'pulse-chart')
  	@oxygen_chart = createChart('Oxygen', '%', @patient.getData('oxygen_sat_measurements'), 'oxygen-chart')
    @temperature_chart = createChart('Temperature', "\u00B0c", @patient.getData('temperature_measurements'), 'temperature-chart')
    @sys_bp_chart = createChart('Systolic Blood Pressure', "mmHg", @patient.getData('sys_bp_measurements'), 'sys-bp-chart')
    @respiration_rate_chart = createChart('Respiratory Rate', "/mins", @patient.getData('respiration_rate_measurements'), 'respiration-rate-chart')
  end
end
