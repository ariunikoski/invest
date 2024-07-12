
window.handleDayClick = function(forDate) {
  var parentDiv = document.getElementById(forDate);
  var alldayDivs = parentDiv.getElementsByClassName('allday');
 
  var root = document.createElement('div')
  root.appendChild(createDateLine(forDate))
  var toast = document.getElementById('toast')
  toast.innerHTML = '';
 
  toast.appendChild(root)
 
  for (var i = 0; i < alldayDivs.length; i++) {
    root.appendChild(createCalendarLine(alldayDivs[i].textContent.replace(/[\r\n]+$/, '')))
  }
  
  root.appendChild(createCloseButton(toast))
  toast.classList.remove('hidden')
}

function createDateLine(forDate) {
 dateline = document.createElement('div')
 dateline.classList.add('toast_dateline')
 dateline.innerText = `Details for ${forDate}`
 return dateline
}

function createCalendarLine(text) {
 calendarLine = document.createElement('div')
 calendarLine.classList.add('toast_calendar_line')
 calendarLine.innerText = text
 return calendarLine
}

function createCloseButton(toast) {
  closeButtonDiv = document.createElement('div')
  closeButtonDiv.classList.add('close_button_div')
  closeButton = document.createElement('button')
  closeButton.textContent = 'Close'
  closeButton.onclick = function() {
	toast.classList.add('hidden')
  }
  closeButtonDiv.appendChild(closeButton)
  return closeButtonDiv
}

window.emailClick = function(theRow) {
  var toast = document.getElementById('toast')
  toast.innerHTML = '';
  var attributes = theRow.attributes
  var root = document.createElement('div')
  root.appendChild(createEmailDateLine(attributes))
  root.appendChild(createEmailFromLine(attributes))
  root.appendChild(createEmailSubjectLine(attributes))
  root.appendChild(createEmailBody(attributes))
  
  toast.appendChild(root)
  root.appendChild(createCloseButton(toast))
  toast.classList.remove('hidden')
}

function createEmailDateLine(attributes) {
	var line = document.createElement('div')
	createPromptAndVal(attributes, line, 'Date:', 'data-mail-date')
	return line
}

function createEmailFromLine(attributes) {
	var line = document.createElement('div')
	createPromptAndVal(attributes, line, 'From:', 'data-mail-from')
	return line
}

function createEmailSubjectLine(attributes) {
	var line = document.createElement('div')
	createPromptAndVal(attributes, line, 'Subject:', 'data-mail-subject')
	return line
}

function createEmailBody(attributes) {
	var line = document.createElement('div')
	line.classList.add('toast_email_body')
	line.id = 'email_body'
	// >>> line.innerText = attributes.getNamedItem('data-mail-body').value
    line.appendChild(createEmailButton(attributes))
	return line
}
	
function createEmailButton(attributes) {
	var button = document.createElement('button');
	button.innerHTML = 'Load Email Body';
	button.onclick = (function(email_id, button) {
    	return function() {
    		var url = 'dashboard/load_email_body?id=' + encodeURIComponent(email_id);
       		var email_body_div = document.getElementById('email_body')
       		email_body_div.innerHTML = 'loading...'
    		fetch(url)
        		.then(response => {
            		if (!response.ok) {
                		throw new Error('Network response was not ok ' + response.statusText);
            		}
            		readStream(response.body).then((responseText) => {
	            		var email_body_div = document.getElementById('email_body')
 		         		email_body_div.innerHTML = responseText
					})
         		})
        		.catch(error => {
            		alert('There was a problem with your fetch operation: ' + error.message)
        		})
    	}
	})( attributes.getNamedItem('data-mail-email-id').value)
	return button
}
	
async function readStream(stream) {
  console.log('>>> readStream commenced v2')
  const reader = stream.getReader();
  const decoder = new TextDecoder();
  let data = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) {
        break;
      }
      data += decoder.decode(value, { stream: true });
    }
    console.log('>>> Stream complete');
    console.log('>>> data is ', data);
  } catch (error) {
    console.error('Stream reading error:', error);
    data = 'Stream reading error - see console'
  } finally {
    reader.releaseLock();
  }
  console.log('>>> about to return', data)
  return data
}


function createPromptAndVal(attributes, line, promptText, valAttributeName) {
	var prompt = document.createElement('span')
	prompt.classList.add('toast_prompt')
	prompt.innerText = promptText
	line.appendChild(prompt)
	
	var val = document.createElement('span')
	val.classList.add('toast_val')
	var valText = attributes.getNamedItem(valAttributeName).value
	val.innerText = valText
	line.appendChild(val)
	return line
}