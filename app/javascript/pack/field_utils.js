function turnOnField(source, data_key, field_span_key, input_key) {
	console.log('>>> double clicked with: ', source, data_key, field_span_key, input_key)
	let dataVal = document.getElementById(data_key).innerText.replace(/^ /, "")
	console.log('>>> dataVal[' + dataVal + "]")
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

function handleInputChar(event, objId, table_name, field_name, data_key, field_span_key, input_key, enable_return = true) {
	const extra_key = enable_return ? 13 : 9
	if (event.keyCode === extra_key || event.keyCode === 9) {
		event.preventDefault()
		updateField(objId, table_name, field_name, data_key, field_span_key, input_key)
	}
	if (event.keyCode === 27) {
		event.preventDefault()
		cancelUpdateField(data_key, field_span_key)
	}
}

function updateField(objId, table_name, field_name, data_key, field_span_key, input_key) {
	console.log('>>> Going to update: ', objId, table_name, field_name, data_key, field_span_key, input_key)
	const origDataVal = document.getElementById(input_key).value
	console.log(">>> origDataVal = ", origDataVal)
	const dataVal = origDataVal.replace(/\n/g,"<p>")
	console.log('>>> dataVal = ', dataVal)
	
	var xhr = new XMLHttpRequest();
  
    var url = `${table_name.toLowerCase()}s/${objId}?${table_name}={"${field_name}":"${dataVal}"}`
    console.log( '>>> url = ', url)
    xhr.open("PUT", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState === 4) {
        if (this.status !== 200) {
		  console.log('failure in update')
		  origDataVal = 'Update failed'
		}
    	document.getElementById(data_key).innerText = origDataVal
	
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

function showSpinner () {
  document.getElementById("spinner").classList.add("show");
}

function hideSpinner() {
  document.getElementById("spinner").classList.remove("show");
}

function show_inner_tab(elem, tab_id) {
  tab_headings = elem.parentElement.children
  console.log('>>> tab_headings:', tab_headings)
  for (let ii = 0; ii < tab_headings.length; ii++) {
    const element = tab_headings[ii];
    console.log('>>> now doing ', element, element.id);
    removeClass(element.id, "current_link")
    addClass(element.id, "page_link")
  }
  tab_divs = elem.parentElement.parentElement.children
  for (let ii = 0; ii < tab_divs.length; ii++) {
    const element = tab_divs[ii];
    if (element.id && element.id.startsWith("inner_tab")) {
		console.log(">>> going to hide", element.id)
		makeInvisible(element.id)
	}
  }
  console.log('>>> tab_divs:', tab_divs)
  addClass(elem.id, "current_link")
  removeClass(elem.id, "page_link")
  
  makeVisible(tab_id)
}