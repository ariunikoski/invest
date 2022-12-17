module Yahoo
  require 'rest-client'
  class HistoricalData
    def initialize(share, symbol, region)
      @share = share
      @symbol = symbol
      @region = region
    end
 
    # Symbol	Region
    # ----------------
    # IBM		US
    # ATRY.TA   TA
    # NAB.AX    AX
    # AQN.TO    TO
    # TODO: calculate symbol and region from share, not via params
    # TODO: add button to screen to run it
    # TODO: add order by for holdings and dividends
    
    # TODO: think about mechanism for marking guys that need to have this run....
    
    # TODO: elsewhere - copy first and then open the link
    
    def load
      begin
        response =  RestClient.get("https://yh-finance.p.rapidapi.com/stock/v3/get-historical-data", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
          'params': {'symbol': @symbol, 'region': @region}
        })
      rescue => e
        puts "Failed to get data for: #{@symbol}, #{@region} with #{e}"
        return
      end
      if response.code != 200
        puts "Failed to get data for: #{@symbol}, #{@region} with #{response.code}"
        return
      end
      data = JSON.parse(response.body)
      handle_dividends(data['eventsData'])
    end
    
    def handle_dividends(events)
      events.each do |event|
        if event['type'] == 'DIVIDEND'
          handle_dividend event
        end
      end
    end
    
    def handle_dividend dividend
      x_date = Time.at(dividend['date']).to_date
      newDiv = Dividend.new(x_date: x_date, amount: dividend['amount'])
      begin
        @share.dividends << newDiv
      rescue => e
        if e.to_s.starts_with?('Mysql2::Error: Duplicate entry')
          puts "Dividend for #{@share.name} on data #{x_date} already exists"
        else
          puts 'Create dividend failed with ', e
        end
      end
    end
  end
end
