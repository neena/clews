class PatientsController < ApplicationController
  include ChartHelper

  def index
    @ward = params[:ward]
    @filter = Patient.select(:ward).distinct.select{|p| p.ward?}.collect{|p| ["Ward #{p.ward}", p.ward]}.unshift(["All Wards", "all"])
    if @ward && @ward != "all"
      @patients = Patient.where(ward: params[:ward])
      @title = "Patients From Ward #{@ward}"
    else
    	@patients = Patient.all
      @title = "Patients From All Wards"
    end
  end

  def show
  	@patient = Patient.find_by_mrn(params[:id]) || Patient.find(params[:id])

    #Create charts
  	@pulse_chart = createChart('Pulse', 'bpm', 'pulse')
  	@oxygen_chart = createChart('Oxygen', '%', 'oxygen sat')
    @temperature_chart = createChart('Temperature', "\u00B0c", 'temperature')
    @respiration_rate_chart = createChart('Respiratory Rate', "/mins", 'respiration rate')
    @bp_chart = Highcharts.new do |chart|
      chart.chart(renderTo: 'bp-chart', type: 'column', events: {load:"renderImages", redraw:"renderImages"})
      chart.title('Blood Pressure')
      chart.plotOptions(column: {pointWidth:20})
      chart.xAxis(type: 'datetime', minorTickInterval: 14400000, dateTimeLabelFormats: {day: '%e %b %y', hour: '%I:%M%P'})
      chart.yAxis(title: "Blood Pressure (mmHg)")
      chart.series(name: @patient.name,borderWidth: 0,data: @patient.getData('bp_measurements'), color: 'rgba(10,10,10,0)')
      chart.legend(enabled: false)
      chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br> Systolic: ' + this.y + 'mmHg <br> Diastolic: ' + this.point.low + 'mmHg '; }")
    end
  end
end
