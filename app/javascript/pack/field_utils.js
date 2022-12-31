function turnOnField(source, data_key, field_span_key, input_key) {
	console.log('>>> double clicked with: ', source, data_key, field_span_key, input_key)
	let dataVal = document.getElementById(data_key).innerText
	document.getElementById(input_key).value = dataVal
	
	makeInvisible(data_key)
	makeVisible(field_span_key)
	document.getElementById(input_key).focus()
}

function makeVisible(id) {
	removeClass(id, 'hidden')
	addClass(id, 'visible')
}

function makeInvisible(id) {
	removeClass(id, 'visible')
	addClass(id, 'hidden')
}

function addClass(id, className) {
  var element = document.getElementById(id);
  element.classList.add(className);
}

function removeClass(id, className) {
  var element = document.getElementById(id);
  element.classList.remove(className);
}

function handleInputChar(event, objId, table_name, field_name, data_key, field_span_key, input_key) {
	console.log('>>> handleInputChar: ', event.keyCode, field_name, objId, table_name, data_key, field_span_key, input_key)
	if (event.keyCode === 13 || event.keyCode === 9) {
		event.preventDefault()
		updateField(objId, table_name, field_name, data_key, field_span_key, input_key)
	}
	if (event.keyCode === 27) {
		event.preventDefault()
		cancelUpdateField(data_key, field_span_key)
	}
}

function updateField(objId, table_name, field_name, data_key, field_span_key, input_key) {
	console.log('>>> going to update: ', objId, table_name, field_name, data_key, field_span_key, input_key)
	let dataVal = document.getElementById(input_key).value
	// ### do the table update
	document.getElementById(data_key).innerText = dataVal
	
	makeVisible(data_key)
	makeInvisible(field_span_key)
}

function cancelUpdateField(data_key, field_span_key) {
	console.log('>>> cancel: ', data_key, field_span_key)
	makeVisible(data_key)
	makeInvisible(field_span_key)
}