
function getDetails(element, shareId) {
   var xhr = new XMLHttpRequest();
  
    // Making our connection  
    var url = 'shares/' + shareId
    xhr.open("GET", url, true);
  
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          var oldElems = document.getElementsByClassName('selected')
          for (var ii = 0; ii < oldElems.length; ii++) {
			oldElems[ii].classList.remove('selected')
		  }
          element.classList.add('selected')
          var elem = document.getElementById('details_location')
          elem.innerHTML = this.responseText
          launchChart()
        } else {
		  console.log('failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}

function callYahooHistoricals(shareId) {
	console.log('>>> callYahooHistoricals calls for: ', shareId)
    var xhr = new XMLHttpRequest();
  
    var url = 'shares/load_yahoo_historicals/' + shareId
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          console.log('>>> success ', this.responseText);
          var elem = document.getElementById('details_location')
          elem.innerHTML = this.responseText
        } else {
		  console.log('failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
	
}

function getCurrentPrices() {
    var xhr = new XMLHttpRequest();
  
    var url = 'yahoo_current_prices/'
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          console.log('>>> success  get current', this.responseText);
          location.reload()
        } else {
		  console.log('get current prices failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}

function showShareInputForm() {
	makeVisible('new_share')
}

function showHoldingInputForm() {
	purchase_date_field = document.getElementById('purchase_date_field')
	purchase_date_field.DatePickerX.init({
		mondayFirst: false,
		format: 'dd/mm/yy'
	})
	makeVisible('new_holding')
}

function deleteShare(shareId) {
    var xhr = new XMLHttpRequest();
    var url = '/shares/' + shareId
    xhr.open("DELETE", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          console.log('>>> success  success', this.responseText);
          location.reload()
        } else {
		  console.log('delete share failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}

function deleteHolding(holdingId) {
    var xhr = new XMLHttpRequest();
    var url = '/holdings/' + holdingId
    xhr.open("DELETE", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          console.log('>>> success  success', this.responseText);
          location.reload()
        } else {
		  console.log('delete holding failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}

function clearDetails() {
	elem = document.getElementById('details_location')
	elem.innerHTML = ''
}

function exportToExcel() {
    var xhr = new XMLHttpRequest();
    var url = '/export_projected_income'
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          alert('Filename = ' + this.responseText);
        } else {
		  console.log('exportToExcel failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}