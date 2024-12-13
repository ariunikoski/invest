module Yahoo
  require 'rest-client'
  require 'uri'
  require 'net/http'
  class HistoricalData
    def initialize(share)
      @share = share
      @symbol = share.symbol
      awk = @share.symbol.split('.')
      awk[1] = 'US' if awk.length == 1
      @region = awk[1]
      puts "Ready to load for #{@symbol} #{@region}"
      @created = 0
      @duplicated = 0
      @errors = 0
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
        response =  RestClient.get("https://yh-finance.p.rapidapi.com/stock/v3/get-historical-data", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
          'use-ssl': true,
          'params': params
        })
      rescue => e
        mark_error "Failed to get data for: #{@symbol}, #{@region} with #{e}"
        return
      end
      if response.code != 200
        mark_error "Failed to get data for: #{@symbol}, #{@region} with #{response.code}"
        return
      end
      if !response.body.empty?
        data = JSON.parse(response.body)
        handle_dividends(data['eventsData'])
      end
    end
    
    def mark_error(message)
      @errors = @errors + 1
      puts message
      Log.error(message)
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
        @created  = @created + 1
      rescue => e
        if e.to_s.starts_with?('Mysql2::Error: Duplicate entry')
          puts "Dividend for #{@share.name} on data #{x_date} already exists"
          @duplicated = @duplicated + 1
        else
          puts 'Create dividend failed with ', e
          Log.error("Create dividend for #{@symbol} with error  #{e}")
          @errors = @errors + 1
        end
      end
    end
    
    def get_stats
      [@created, @duplicated, @errors]
    end
  end
end
