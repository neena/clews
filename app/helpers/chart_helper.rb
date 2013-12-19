module ChartHelper
  def createChart title, units, data, renderTo
  	@chart = Highcharts.new do |chart|
	  chart.chart(renderTo: renderTo, zoomType: 'x')
	  chart.title(title)
	  chart.xAxis(type: 'datetime', minorTickInterval: 14400000, dateTimeLabelFormats: {day: '%e %b %y', hour: '%I:%M%P'})
	  chart.yAxis(title: "#{title} (#{units})")
	  chart.series(name: @patient.name, data: data)
	  chart.legend(enabled: false)
	  chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br>' + this.y + '#{units}'; }")
    end
  	@chart
  end

  def getEWSColor score, patient
  	case 
  	when score == 0
			"#6d6d6d"
  	when (score < 5 && patient) || (score == 1 && !patient)
  		"#54c72e"
  	when (score < 7 && patient) || (score == 2 && !patient)
  		"#ffa53f"
  	when (score >= 7 && patient) || (score == 3 && !patient)
  		"#ba0001"
  	end	  
  end
end