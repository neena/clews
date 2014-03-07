module ChartHelper

  def getChartData type 
    table = type.gsub(" ","_")+"_measurements"
    data = @patient.getData(table)
    id = type.gsub(" ","-")+"-chart"
    bands = createPlotBands(type)
    if type == "bp"
      title = "Blood Pressure"
      units = "mmHg"
      data.each do |datum|
        datum[:color] = EWSColor(datum[:ews])
      end
    else
      title = table.classify.constantize.human_name
      units = table.classify.constantize.units
    end
    {series: data, title: title, units: units, type: type, id: id, bands: bands}
  end

  def createPdfChart type
    data = getChartData(type)

    @charts = data[:series].each_slice(20).with_index.inject([]) do |charts, (series, index)|
      charts.push(Highcharts.new do |chart|
        chart.chart(renderTo: "#{data[:id]}#{index}", zoomType: 'x')
        chart.title(data[:title]) 
        chart.credits(enabled: false)
        chart.xAxis(type: 'datetime', minorTickInterval: 14400000, dateTimeLabelFormats: {day: '%e %b %y', hour: '%I:%M%P'})
        chart.yAxis(title: "#{data[:title]} #{data[:units].try{|u| "(#{u})"}}", minorTickInterval: 'auto')
        chart.series(name: @patient.name, data: series)
        chart.legend(enabled: false)
        chart.plotOptions(line: { animation: false, enableMouseTracking: false, shadow: false})
        #Handle special case of blood pressure
        if type == "bp" 
          chart.chart(renderTo: "#{data[:id]}#{index}", type: 'column')#, events: {load:"renderImages", redraw:"renderImages"}) I'm deprecating this. 
          chart.plotOptions(column: {pointWidth:5})
          chart.series(name: @patient.name,borderWidth: 0,data: series, color: "rgba(255,0,0,0)")
          chart.tooltip(formatter: "function(){ return '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br> Systolic: ' + this.y + 'mmHg <br> Diastolic: ' + this.point.low + 'mmHg '; }")
        end
      end)
      charts
    end
    @charts
  end

  def createPlotBands type
    bands = []
    bounds = EWSConfig[type.gsub(" ","_").classify]
    
    #Some setup
    big_number = 1000

    
    if bounds
      bands.push(from: 0, to: bounds['min0'], color: lighten_color(EWSColor(1)))
      bands.push(from: bounds['max0'], to: big_number, color: lighten_color(EWSColor(1)))
      bands.push(from: 0, to: bounds['min1'], color: lighten_color(EWSColor(2)))
      bands.push(from: bounds['max1'], to: big_number, color: lighten_color(EWSColor(2)))
      bands.push(from: 0, to: bounds['min2'], color: lighten_color(EWSColor(3)))
      bands.push(from: bounds['max2'], to: big_number, color: lighten_color(EWSColor(3)))
    else
      {}
    end
  end

  # Amount should be a decimal between 0 and 1. Lower means darker
  def darken_color(hex_color, amount=0.4)
    hex_color = hex_color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = (rgb[0].to_i * amount).round
    rgb[1] = (rgb[1].to_i * amount).round
    rgb[2] = (rgb[2].to_i * amount).round
    "#%02x%02x%02x" % rgb
  end
    
  # Amount should be a decimal between 0 and 1. Higher means lighter
  def lighten_color(hex_color, amount=0.2)
    hex_color = hex_color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
    rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
    rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
    "#%02x%02x%02x" % rgb
  end

  def EWSColor score
    case score
    when 0
      "#43EBD3"
    when 1
      "#51AF25"
    when 2
      "#F7AE29"
    when 3
      "#EE442A"
    when nil
      "#B0B5B6"
    end   
  end
end