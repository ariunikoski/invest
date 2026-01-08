function handleRowPreselect(preselect_klass, preselect_klass_id, tab_name) {
	if (preselect_klass === 'Share' && preselect_klass_id > 0) {
		var elem = document.getElementById("share_" + preselect_klass_id)
		getDetails(elem, preselect_klass_id, tab_name)
	}
}

function getDetails(element, shareId, tab_name = null) {
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
          if (tab_name !== null) {
			const tabHeaderName = `tab_header_${tab_name}`
			const tabDivName = `inner_tab_${tab_name}`
			const headerElem = document.getElementById(tabHeaderName)
			show_inner_tab(headerElem, tabDivName)
		  }
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
	initiateDateField('purchase_date_field')
	//purchase_date_field = document.getElementById('purchase_date_field')
	//purchase_date_field.DatePickerX.init({
	//	mondayFirst: false,
	//	format: 'dd/mm/yy'
	//})
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

function toggleFlag(event) {
	event.stopPropagation()
}
	
function deleteHolding(holdingId, desc) {
    var userResponse = confirm("Do you want to delete the holding:" + desc +"?");
	if (!userResponse) {
		return
	}
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

function deleteSale(saleId, desc) {
    var userResponse = confirm("Do you want to delete the sale:" + desc +"?");
	if (!userResponse) {
		return
	}
    var xhr = new XMLHttpRequest();
    var url = '/sales/' + saleId
    xhr.open("DELETE", url, true);
    
    xhr.onreadystatechange = function () {
      if (this.readyState == 4) {
        if (this.status == 200) {
          location.reload()
        } else {
		  console.log('delete sale failure')
		}
      }
    }
    // Sending our request 
    xhr.send();
}

function sellHolding(holding) {
	populateFieldValue('selling_holding_id_field', holding.id)
	populateFieldValue('selling_share_id_field', holding.held_by_id)
	populateFieldValue('selling_amount_field', holding.amount)
	populateFieldValue('selling_account_field', holding.account)
	populateFieldValue('selling_purchase_price_field', holding.cost)
	initiateDateField('selling_sale_date_field')
	makeVisible('sell_holding')
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

function filterByFlag(style) {
	var element = document.getElementById('actions_filter');
	element.dataset.rowFlagFilterVal = style;
	apply_filter() // see: app\javascript\pack\filters.js
}

function populateFieldValue(field_id, value) {
	field = document.getElementById(field_id)
	if (field) {
		field.value = value
	}
}

function initiateDateField(field_id) {
	date_field = document.getElementById(field_id)
	date_field.DatePickerX.init({
		mondayFirst: false,
		format: 'dd/mm/yy'
	})
}

function populateAccountFilters() {
  document.querySelectorAll("table.shares_table").forEach(table => {
    const headerCells = table.querySelectorAll("thead th");

    // Find the index of the header with class "accounts_col"
    let accountColIndex = -1;
    headerCells.forEach((th, i) => {
      if (th.classList.contains("accounts_col")) {
        accountColIndex = i;
      }
    });

    if (accountColIndex === -1) return; // no accounts_col found in this table
    // Collect all span values in that column
    let values = new Set();
    table.querySelectorAll("tbody tr").forEach(row => {
      const cell = row.cells[accountColIndex];
      if (!cell) return;
      cell.querySelectorAll("sp").forEach(span => {
        values.add(span.textContent.trim());
      });
    });

    // Sort values
    const sorted = Array.from(values).sort();

    // Find the filter container div
    const filterDiv = headerCells[accountColIndex].querySelector(".accounts_filter_list");
    if (!filterDiv) return;

    // Clear existing
    filterDiv.innerHTML = "";

    // Add checkboxes
    sorted.forEach(val => {
      const label = document.createElement("label");
      label.style.display = "block"; // one per line (optional)

      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.name = val;
      checkbox.value = val;
      checkbox.checked = true; // initially set to true

      label.appendChild(checkbox);
      label.append(" " + val);
      filterDiv.appendChild(label);
    });
  });
}

function markAlertStatusChange(statusChanger, selectedValue, newDate = null, data_key = null) {
  const id_val = statusChanger.id.replace(/^alert_status_/, "");
  const statusCol = document.getElementById(`old_status_${id_val}`)
  const ignoreUntilCol = document.getElementById(`old_ignore_until_${id_val}`)
  statusCol.innerText = selectedValue
  const row = statusCol.parentElement
  row.classList.remove("alert_style_new")
  row.classList.remove("alert_style_renew")
  row.classList.remove("alert_style_finished")
  row.classList.add("alert_style_updated")
  if (newDate) {
    ignoreUntilCol.innerText = newDate
  }
  statusChanger.value = "NO_CHANGE"
  var xhr = new XMLHttpRequest();
  
  var url = 'load_rates'
  showSpinner()
  xhr.open("POST", "/alerts/set_alert_status", true);
    
  xhr.onreadystatechange = function () {
    if (this.readyState == 4) {
	  	hideSpinner()
      if (this.status == 200) {
        
      } else {
        alert(`Failed with status: ${this.status}`)
      }
    }
    // Sending our request 
  }
  xhr.setRequestHeader("Content-Type", "application/json");
  xhr.send(JSON.stringify({id: id_val, status: selectedValue, ignore_until: newDate }));
}

function pollForDatePickerVisible(data_key, statusChanger) {
    const dateTextField = document.getElementById(data_key);
    const sibling = dateTextField.nextElementSibling;
    if (!sibling.classList.contains("date-picker-x")) {
      alert("Error: should have got date-picker-x and did not - you will not be able to set the date")
      return
    }
    if (sibling.classList.contains("active")) {
      schedulePollForDatePickerVisible(data_key, statusChanger)
      return
    }
    const theDate = dateTextField.value.trim()
    if (theDate !== "") {
      markAlertStatusChange(statusChanger, "IGNORE_UNTIL", theDate, data_key)
    }
    makeInvisible(data_key)
    statusChanger.value = "NO_CHANGE"
}


function schedulePollForDatePickerVisible(data_key, statusChanger) {
  setTimeout(() => {
    pollForDatePickerVisible(data_key, statusChanger);
  }, 500);
}

function changeAlertStatus(statusChanger) {
  const selectedValue = statusChanger.value;
  const alertId = statusChanger.name.split('_').pop(); // assumes name like alert_status_123

  if (selectedValue === "IGNORE_UNTIL") {
    const data_key = `ignore_until_${alertId}_field`
    
    setTimeout(() => {
      turnOnField(null, data_key, data_key, data_key, true)
      schedulePollForDatePickerVisible(data_key, statusChanger);
    }, 1000);

  } else {
    markAlertStatusChange(statusChanger, selectedValue)
  }
}

document.addEventListener("DOMContentLoaded", populateAccountFilters);

