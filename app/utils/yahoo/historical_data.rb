module Yahoo
  require 'rest-client'
  class HistoricalData
    def initialize(share)
      @share = share
      @symbol = share.symbol
      awk = @share.symbol.split('.')
      awk[1] = 'US' if awk.length == 1
      @region = awk[1]
      puts "Ready to load for #{@symbol} #{@region}"
    end
 
    # Symbol	Region
    # ----------------
    # IBM		US
    # ATRY.TA   TA
    # NAB.AX    AX
    # AQN.TO    TO
    # documentation suggests region is optional - try without
    # create my own user... in rapid api
    # TODO: add order by for holdings and dividends
    # TODO: yahoo - get current price and update... this can also set the last dividend payment date
    
    # TODO once current price, I can do my own trailing ytd, and then percent of current, and weighted percent against investment - and projected income.
    # 
    
    # TODO: think about mechanism for marking guys that need to have this run....
    
    # TODO: elsewhere - copy first and then open the link
    
    def load
      begin
        params = {'symbol': @symbol, 'region': @region}
        puts '>>> params = ', params, params.to_json
        response =  RestClient.get("https://yh-finance.p.rapidapi.com/stock/v3/get-historical-data", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
          'params': params
        })
      rescue => e
        puts "Failed to get data for: #{@symbol}, #{@region} with #{e}"
        return
      end
      if response.code != 200
        puts "Failed to get data for: #{@symbol}, #{@region} with #{response.code}"
        return
      end
      puts '>>> empty?', response.body, response.body.empty?
      if !response.body.empty?
        data = JSON.parse(response.body)
        handle_dividends(data['eventsData'])
      end
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
