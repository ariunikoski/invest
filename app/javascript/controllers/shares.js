
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
          const key = `data_Share_comments_${shareId}`
          setTimeout(function() { reformat(key)}, 500)
          launchChart()
        } else {
		  console.log('failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}

function reformat(key) {
	const elem = document.getElementById(key)
	const dataVal = elem.innerText.replace(/\n/g,"").replace(/<p>/g,"\n").trimStart()
	console.log('>>> before [' + dataVal + ']')
	elem.innerText = dataVal
}

function callYahooHistoricals(shareId) {
    var xhr = new XMLHttpRequest();
  
    var url = 'shares/load_yahoo_historicals/' + shareId
    showSpinner()
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
	    hideSpinner()
        if (this.status == 200) {
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

function callYahooSummary(shareId) {
    var xhr = new XMLHttpRequest();
  
    var url = 'shares/load_yahoo_summary/' + shareId
    showSpinner()
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
	    hideSpinner()
        if (this.status == 200) {
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
    showSpinner()
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        hideSpinner()
        if (this.status == 200) {
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
    var userResponse = confirm("Do you want to delete the share?");
	if (!userResponse) {
		return
	}

    xhr.open("DELETE", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
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
    showSpinner()
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        hideSpinner()
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

function getBreakdownBySector() {
	location.href = '/breakdown_by_sector'
}

function getBreakdownBySectorCondensed() {
	location.href = '/breakdown_by_sector_condensed'
}

function loadAllDividends() {
    var xhr = new XMLHttpRequest();
    var url = '/load_all_dividends'
    showSpinner()
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        hideSpinner()
        if (this.status == 200) {
          location.reload()
        } else {
		  console.log('load all dividends failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
	
}