module CurrencyConverter
  require 'rest-client'
  class CurrencyConverter
    def initialize(currency_code)
      @currency_code = currency_code
    end

    def load
      begin
        params = {'have': @currency_code, 'want': 'ILS', 'amount': '1'}
        response =  RestClient.get("https://currency-converter-by-api-ninjas.p.rapidapi.com/v1/convertcurrency", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'currency-converter-by-api-ninjas.p.rapidapi.com',
          'params': params
        })
      rescue => e
        puts "Failed to get data for: #{@currency_code}"
        return -1
      end
      if response.code != 200
        puts "Failed to get data for: #{@currency_code}"
        return -1
      end
      if !response.body.empty?
        data = JSON.parse(response.body)
        puts 'response = ', data
        return data["new_amount"]
      end
      return -1
    end
  end
end