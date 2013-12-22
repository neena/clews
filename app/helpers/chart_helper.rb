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

  def EWSColor score
  	case score
  	when 0
			"#6d6d6d"
  	when 1
  		"#54c72e"
  	when 2
  		"#ffa53f"
  	when 3
  		"#ba0001"
  	end	  
  end
end