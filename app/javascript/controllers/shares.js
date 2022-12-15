function getDetails() {arguments
    console.log(">>> here all along")
    var xhr = new XMLHttpRequest();
  
    // Making our connection  
    var url = 'shares/details'
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