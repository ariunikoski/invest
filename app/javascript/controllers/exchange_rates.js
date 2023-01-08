function loadRates() {
    var xhr = new XMLHttpRequest();
  
    var url = 'load_rates'
    xhr.open("GET", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          console.log('>>> success  load_rates', this.responseText);
          location.reload()
        } else {
		  console.log('load_rates')
		}
      }
    }
    // Sending our request 
    xhr.send();
}