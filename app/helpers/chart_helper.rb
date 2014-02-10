module ChartHelper
	def createChart title, type, pdf=false
		@table = type.gsub(" ","_")+"_measurements"
		puts @table
		data = pdf ? @patient.getData(@table).each_slice(20).to_a : [@patient.getData(@table)]

		@charts = data.each_with_index.inject([]) do |charts, (data, index)|
			charts.push(Highcharts.new do |chart|
				renderto = type.gsub(" ","-")+"-chart#{pdf ? index : ''}"
				chart.chart(renderTo: renderto, zoomType: 'x')
				chart.title(!pdf ? title : "") 
				chart.credits(enabled: false)
				chart.xAxis(type: 'datetime', minorTickInterval: 14400000, dateTimeLabelFormats: {day: '%e %b %y', hour: '%I:%M%P'})
				chart.yAxis(title: (type != "bp" ? @table.classify.constantize.title : "Blood Pressure (mmHg)"), minorTickInterval: 'auto')
				chart.series(name: @patient.name, data: data)
				chart.legend(enabled: false)
				chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br>' + this.y + '#{type != "bp" ? @table.classify.constantize.try{|c| c.units} : "mmHg"}'; }")
				chart.plotOptions(line: { animation: false, enableMouseTracking: false, shadow: false}) if pdf
				#Handle special case of blood pressure
				if type == "bp" 
					if pdf
						chart.chart(renderTo: renderto, type: 'column', events: {load:"renderImages", redraw:"renderImages"})
						chart.plotOptions(column: {pointWidth:20})
					else
						chart.chart(renderTo: renderto, type: 'column', zoomType: 'x')
						chart.plotOptions(column: {pointWidth:10})
					end
					chart.series(name: @patient.name,borderWidth: 0,data: data, color: "rgba(255,0,0,#{pdf ? 0 : 1})")
					chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br> Systolic: ' + this.y + 'mmHg <br> Diastolic: ' + this.point.low + 'mmHg '; }")
				end
			end)
		end
		pdf ? @charts : @charts.first

		#THIS NEEDS A TIDY UP DREADFULLY. DO IT. 
		#MAYBE SWITCH TO D3, OR ACTUALLY WRITE SOME JAVASCRIPT
		#I DON'T CARE BUT THIS GEM IS A MESS AND YOU'RE NOT HELPING ANYONE. 

		#Its really quite ugly code tbh. 
		#Just use Javascript ffs. 

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