@reloadFormAs = (patientID) ->
	$('#main').load(document.URL+" #content", "patient_id="+patientID)