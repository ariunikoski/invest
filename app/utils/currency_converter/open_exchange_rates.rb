module CurrencyConverter
  require 'uri'
  require 'net/http'
  class OpenExchangeRates
    def initialize
      @rates = {}
      begin
        puts 'Loading all exchange rates via OpenExchangeRates'
        app_id = '65120f06978e42ac96db10666a60ba3e'
        url = URI("https://openexchangerates.org/api/latest.json?app_id=#{app_id}&show_alternative=false")
  
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
  
        request = Net::HTTP::Get.new(url)
        request["accept"] = 'application/json'

        response = http.request(request)
        puts '>>> response.code', response.code
      rescue => e
        puts "Failed to get data with error #{e}"
        Log.error "Failed to get data with error #{e}"
        return
      end
      if response.code.to_i != 200
        puts "Failed to get data with response code #{response.code}"
        Log.error "Failed to get data with response code #{response.code}"
        return
      end
      if !response.body.empty?
        @rates = JSON.parse(response.body)['rates']
        @rates['USD'] = 1
        puts ' >>> response = ', @rates
        #return data["new_amount"]
      end 
    end
    
    def get_rate(currency)
      israel_rate = @rates['ILS']
      if !israel_rate
        puts 'Failed to find israeli rate'
        Log.error 'Failed to find israeli rate'
        return nil
      end
      other_rate = @rates[currency]
      if !other_rate
        puts "Failed to find #{currency} rate"
        Log.error "Failed to find #{currency} rate"
        return nil
      end
      israel_rate / other_rate
    end
  end #class
end #module
