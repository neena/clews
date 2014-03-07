class PatientsController < ApplicationController
  include ChartHelper

  before_action :filters, only: [:index, :rounds]

  def index
    if @ward && @ward != "all"
      @patients = Ward.find(@ward).patients
    else
      @patients = Patient.all
    end

    if @order == 'EWS'
      @patients = @patients.sort_by{|p| [- p.getEWS[:score], p.surname]}
    else
      @patients = @patients.sort_by(&:surname)
    end

    respond_to do |format|
      format.html
      format.json { render json: @patients.to_json(methods: [:getEWS]) }
    end
  end

  def rounds
    if @ward && @ward != "all"
      ward = Ward.find(@ward)
      @patients = (ward.patients.due_observation(1) + ward.patients.no_observation).flatten
    else
      @patients = (Patient.due_observation(1) + Patient.no_observation).flatten
    end

    respond_to do |format|
      format.html
      format.json { render json: @patients.to_json(methods: [:getEWS]) }
    end
  end

  def show
    respond_to do |format|
      format.json do
        load_patient_and_charts
        render json: @patient.to_json(methods: [:latest_observations])
      end
      format.html do
        load_patient_and_charts
      end
      format.pdf do
        load_patient_and_charts true
        render  :pdf => "patient-#{@patient.name}-#{@patient.mrn}",
            :template => 'patients/pdf.html.haml',
            :layout => "pdf.html",
            :redirect_delay => 1000,
            :margin => {top: 5, bottom: 5, left: 5, right: 5},
            :footer => { :right => "Page [page] of [topage]\n" }
      end
    end
  end

  def download
    load_patient_and_charts true

    pdf_file = render_to_string :pdf => "patient-#{@patient.name}-#{@patient.mrn}",
                  :template => 'patients/pdf.html.haml',
                  :layout => "pdf.html",
                  :redirect_delay => 1000,
                  :margin => {top: 5, bottom: 5, left: 5, right: 5},
                  :footer => { :right => "Page [page] of [topage]\n" }
    send_data pdf_file, :type => 'pdf', :filename => "patient-#{@patient.name}-#{@patient.mrn}.pdf"
  end

  def destroy
    @patient = Patient.find_by_mrn(params[:id]) || Patient.find(params[:id])
    redirect_to patients_url
    @patient.destroy
  end

  private
  def load_patient_and_charts pdf=false
    @patient = Patient.find_by_mrn(params[:id]) || Patient.find(params[:id])

    #Create charts
    if pdf
      @pulse_chart = createPdfChart('pulse')
      @oxygen_chart = createPdfChart('oxygen sat')
      @temperature_chart = createPdfChart('temperature')
      @respiration_rate_chart = createPdfChart('respiration rate')
      @bp_chart = createPdfChart('bp')
    else
      @charts_data = [
        getChartData('pulse'),
        getChartData('oxygen sat'),
        getChartData('temperature'),
        getChartData('respiration rate'),
        getChartData('bp')
      ]
    end
    #   @pulse_chart = createChart('Pulse', 'pulse', pdf)
    #   @oxygen_chart = createChart('Oxygen', 'oxygen sat', pdf)
    #   @temperature_chart = createChart('Temperature', 'temperature', pdf)
    #   @respiration_rate_chart = createChart('Respiratory Rate', 'respiration rate', pdf)
    #   @bp_chart = createChart('Blood Presure', 'bp', pdf)
    # end
  end

  def filters
    @ward = params[:ward] || cookies[:ward]
    cookies.delete :ward
    cookies.permanent[:ward] = @ward || "all"

    if params[:action] == 'index'
      @order = params[:order] || cookies[:order]
      cookies.delete :order
      cookies.permanent[:order] = @order || "Surname"
    end

    @ward_filter = Patient.select(:ward_id).distinct.select{|p| p.ward_id?}.sort_by{|p| p.ward.name}.collect{|p| [p.ward.name, p.ward.id]}.unshift(["All Wards", "all"])
    @order_filter = ['Surname','EWS']
  end
end
