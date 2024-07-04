module Weather
  require 'httparty'
  require 'json'
  
  class Api
    include HTTParty
    base_uri 'http://api.weatherapi.com/v1'
  
    def initialize(city)
      @api_key = '9d74f3d67bfb445da6803848240905'
      begin
        get_weather(city)
      rescue StandardError => e
        puts "An error occurred in getting weather: #{e.message}"
      end
    end
  
    def get_weather(city)
      #response = self.class.get("/current.json?key=#{@api_key}&q=#{city}")
      response = self.class.get("/forecast.json?key=#{@api_key}&q=#{city}&days=2&aqi=yes&alerts=no")
      if response.success?
        @weather_data = JSON.parse(response.body)
      else
        raise "Error fetching weather data: #{response.code} - #{response.message}"
      end
    end
    
    def current
      @weather_data["current"]
    end
    
    def forecast
      @weather_data["forecast"]
    end
    
    def forecast_day(date)
      forecast['forecastday'].each do |fday|
        puts '>>> ', fday['date']
        date_key = date.to_s
        return fday if fday['date'] == date_key
      end
      nil
    end
  end #Class
end #Module
  
