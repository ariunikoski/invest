
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
	line.innerText = attributes.getNamedItem('data-mail-body').value
	return line
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