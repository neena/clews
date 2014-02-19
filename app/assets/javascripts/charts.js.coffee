$ ->
	Highcharts.setOptions({
		chart: {
			zoomType: 'x'
		},
		credits: {
			enabled: false
		},
		xAxis: {
			type: 'datetime',
			minorTickInterval: 14400000, 
			dateTimeLabelFormats: {
				day: '%e %b %y', 
				hour: '%I:%M%P'
			}
		},
		yAxis: {
			minorTickInterval: 'auto'
		},
		legend: {
			enabled: false
		}
		tooltip: {
			formatter: -> '<b>' + new Date(this.x).toLocaleString('en-GB') + '</b> <br>' + this.y
		}
	})

	$('.chart').each ->
		console.log($(@).attr("data-series"))
		$(@).highcharts({
			chart: {
				renderTo: $(@).attr("id")
			},
			title: {
				text: $(@).data("title")
			},
			yAxis: {

			},
			series: [{
				data: $(@).data("series")
			}]
		})