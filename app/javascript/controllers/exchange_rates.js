function loadRates() {
    var xhr = new XMLHttpRequest();
  
    var url = 'load_rates'
    showSpinner()
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
		hideSpinner()
        if (this.status == 200) {
          location.reload()
        } else {
		}
      }
    }
    // Sending our request 
    xhr.send();
}