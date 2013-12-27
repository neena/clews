renderImages = function() {
	var chart = this,
		d = chart.series[0].data;

	for (var i = 0, len = d.length; i < len; i++) {
		var p = d[i],
			x = chart.plotLeft + p.plotX,
			y = chart.plotTop + p.plotY,
			w = p.pointWidth,
			h = p.graphic.height;

		//Arrows
		chart.renderer.path(['M',x-10,y-10,'l',10,10,10,-10,'M',x-10,y+h+10,'l',10,-10,10,10])
			.attr({
					'stroke-width': 2,
					stroke: 'black'
			})
			.add();	

		// Dashed line
		chart.renderer.path(['M',x,y,'l',0,h])
			.attr({
					'stroke-width': 3,
					stroke: 'black',
					'stroke-dasharray': "10,10"
			})
			.add();	
	}
}