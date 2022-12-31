function getDetails(element, shareId) {
   var xhr = new XMLHttpRequest();
  
    // Making our connection  
    var url = 'shares/' + shareId
    xhr.open("GET", url, true);
  
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          console.log('>>> success ', this.responseText);
          var oldElems = document.getElementsByClassName('selected')
          console.log('>>> oldElems = ', oldElems)
          for (var ii = 0; ii < oldElems.length; ii++) {
			oldElems[ii].classList.remove('selected')
		  }
          element.classList.add('selected')
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