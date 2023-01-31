function turnOnField(source, data_key, field_span_key, input_key) {
	console.log('>>> double clicked with: ', source, data_key, field_span_key, input_key)
	let dataVal = document.getElementById(data_key).innerText
	inputElem = document.getElementById(input_key)
	inputElem.value = dataVal
	if (inputElem.classList.contains('datepicker')) {
		console.log('adding datepicker')
		inputElem.DatePickerX.init({
			mondayFirst: false,
			format: 'dd/mm/yy'
		})
	}
	
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
	
	var xhr = new XMLHttpRequest();
  
    var url = `${table_name.toLowerCase()}s/${objId}?${table_name}={"${field_name}":"${dataVal}"}`
    console.log( '>>> url = ', url)
    xhr.open("PUT", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState === 4) {
        if (this.status !== 200) {
		  console.log('failure in update')
		  dataVal = 'Update failed'
		}
    	document.getElementById(data_key).innerText = dataVal
	
		makeVisible(data_key)
		makeInvisible(field_span_key)
      }
    }
    // Sending our request 
    xhr.send();
}

function cancelUpdateField(data_key, field_span_key) {
	console.log('>>> cancel: ', data_key, field_span_key)
	makeVisible(data_key)
	makeInvisible(field_span_key)
}

function clearLog() {
	makeInvisible('log-toast')
	
    var xhr = new XMLHttpRequest();
  
    var url = '/clear_logs'
    xhr.open("PUT", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
   		  console.log('clear logs success')
        } else {
		  console.log(' clear logs failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
	
}

