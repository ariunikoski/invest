 function launchChart() {
    new TradingView.MediumWidget({
      "symbols": [
        [
          "FIBI",
          "TASE:FIBIH|12M"
        ],
        [
          "Apple",
          "AAPL|1D"
        ],
        [
          "Google",
          "GOOGL|1D"
        ],
        [
          "Microsoft",
          "MSFT|1D"
        ],
        [
          "ANZ",
          "ASX:ANZ|12M"
        ],
        [
          "TorontoD",
          "TSX:TD|12M"
        ]
      ]
      ,
      "chartOnly": false,
      "width": "100%",
      "height": "100%",
      "locale": "en",
      "colorTheme": "light",
      "autosize": false,
      "width": "700",
      "height": "500",
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
      "container_id": "tradingview_b3291"
    });
  }