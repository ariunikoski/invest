 function launchChart() {
	const masterDivId = "tradingview_b3291"
	const masterDiv = document.getElementById(masterDivId)
	const origSymbol = masterDiv.dataset.shareSymbol
	const shareName = masterDiv.dataset.shareName
	const symbol = convertSymbol(origSymbol)
	console.log('>>> masterDiv = ', masterDiv)
	console.log('>>> masterDiv.dataset = ', masterDiv.dataset)
	console.log('>>> shreName = ', shareName)
	console.log('>>> symbok = ', symbol)
    new TradingView.MediumWidget({
      "symbols": [
        [
          shareName,
          `${symbol}|12M`  
        ]
      ]
      ,
      "chartOnly": false,
      "width": "100%",
      "height": "100%",
      "locale": "en",
      "colorTheme": "light",
      "autosize": false,
      "width": "710",
      "height": "300",
      "showVolume": false,
      "hideDateRanges": false,
      "hideMarketStatus": false,
      "scalePosition": "right",
      "scaleMode": "Normal",
      "fontFamily": "-apple-system, BlinkMacSystemFont, Trebuchet MS, Roboto, Ubuntu, sans-serif",
      "fontSize": "10",
      "noTimeScale": false,
      "valuesTracking": "1",
      "chartType": "line",
      "dateFormat": "dd-MM-yyyy",
      "container_id": masterDivId
    });
  }
  
  function convertSymbol(inval) {
	  const awk = inval.split('.')
	  if (awk.length < 2) return inval
	  const xlater = {
		  TA: 'TASE',
		  AX: 'ASX',
		  TO: 'TSX'
	  }
	  prefix = xlater[awk[1]]
	  if (!prefix) return `${awk[1]} not found`
	  return `${prefix}:${awk[0]}`
  }