module Yahoo
  require 'rest-client'
  class HistoricalData
    def load
      #@response =  RestClient.get "https://developers.zomato.com/api/v2.1/cities?q=#{params["city"]}",
    #{content_type: :json, accept: :json, "user-key": ENV["API_KEY"]}
      @response =  RestClient.get("https://yh-finance.p.rapidapi.com/stock/v3/get-historical-data", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
          'params': {'symbol': "IBM", 'region': "US"}
      })
      puts '>>> response = ', @response
    end
  end
end
