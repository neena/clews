module ChartHelper
  def createChart title, units, type, pdf=false
    @table = type.gsub(" ","_")+"_measurements"
  	@chart = Highcharts.new do |chart|
  	  chart.chart(renderTo: type.gsub(" ","-")+"-chart", zoomType: 'x')
  	  chart.title(title)
      chart.credits(enabled: false)
  	  chart.xAxis(type: 'datetime', minorTickInterval: 14400000, dateTimeLabelFormats: {day: '%e %b %y', hour: '%I:%M%P'})
  	  chart.yAxis(title: "#{title} (#{units})")
  	  chart.series(name: @patient.name, data: @patient.getData(@table))
  	  chart.legend(enabled: false)
  	  chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br>' + this.y + '#{units}'; }")
      chart.plotOptions(line: { animation: false, enableMouseTracking: false, shadow: false}) if pdf
      #Handle special case of blood pressure
      if type == "bp" 
        chart.chart(renderTo: type.gsub(" ","-")+"-chart", zoomType: 'x', type: 'column', events: {load:"renderImages", redraw:"renderImages"})
        chart.plotOptions(column: {pointWidth:20})
        chart.series(name: @patient.name,borderWidth: 0,data: @patient.getData('bp_measurements'), color: 'rgba(10,10,10,0)')
        chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br> Systolic: ' + this.y + 'mmHg <br> Diastolic: ' + this.point.low + 'mmHg '; }")
      end
    end
  	@chart
  end

  def createPlotBands type
    bands = []
    bounds = EWSConfig[type]
    if bounds
      bands.push(from: bounds['min0'], to: bounds['max0'], color: EWSColor(0))
      bands.push(from: bounds['min1'], to: bounds['min0'], color: EWSColor(1))
      bands.push(from: bounds['max0'], to: bounds['max1'], color: EWSColor(1))
      bands.push(from: bounds['min2'], to: bounds['min1'], color: EWSColor(2))
      bands.push(from: bounds['max1'], to: bounds['max2'], color: EWSColor(2))
      bands.push(from: bounds['max2'], to: bounds['max2']*10, color: EWSColor(3))
      bands.push(from: 0, to: bounds['min2'], color: EWSColor(3))
    else
      {}
    end
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