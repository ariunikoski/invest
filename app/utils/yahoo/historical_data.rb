module Yahoo
  require 'rest-client'
  require 'uri'
  require 'net/http'
  class HistoricalData
    def initialize(share, silent = false)
      @share = share
      @silent = silent
      @symbol = share.symbol
      awk = @share.symbol.split('.')
      awk[1] = 'US' if awk.length == 1
      @region = awk[1]
      puts "Ready to load for #{@symbol} #{@region}" unless @silent
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
    
    def load
      begin
        today = Date.today
        five_years = today.prev_year(5)
        query = "https://query1.finance.yahoo.com/v8/finance/chart/#{@symbol}?events=div&formatted=true&includeAdjustedClose=true&interval=1d&period1=#{five_years.to_time.to_i}&period2=#{today.to_time.to_i}&symbol=#{@symbol}&userYfid=true&lang=en-US&region=#{@region}"
        response = RestClient.get(query)
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
        if data["chart"]["result"].length != 1
          mark_error "data['chart']['result'].length was #{data['chart']['result'].length}"
          return
        end
        begin
          dividends = data["chart"]["result"][0]["events"]["dividends"]
        rescue => e
          dividends = nil
        end
        if !dividends
          mark_error "Could not find 'dividends' in #{data}"
          return
        end
        Log.warn("Zero dividends found!") if handle_dividends(dividends) < 1
      else
        mark_error "response.body was empty"
      end
    end
    
    def mark_error(message)
      @errors = @errors + 1
      puts message unless @silent
      Log.error("Error found for #{@share.name}")
      Log.error(message.byteslice(0,255))
    end
    
    def handle_dividends(events)
      dividends_handled = 0
      events.each do |key, value|
        dividends_handled = dividends_handled + 1
        handle_dividend value
      end
      dividends_handled
    end
    
    def handle_dividend dividend
      x_date = Time.at(dividend['date'].to_i).to_date
      if !x_date
        mark_error "No x_date in #{dividend.to_json}"
        return
      end
      if !dividend['amount']
        mark_error "No amount in #{dividend.to_json}"
        return
      end
      newDiv = Dividend.new(x_date: x_date, amount: dividend['amount'])
      begin
        @share.dividends << newDiv
        @created  = @created + 1
      rescue => e
        if e.to_s.starts_with?('Mysql2::Error: Duplicate entry')
          puts "Dividend for #{@share.name} on data #{x_date} already exists" unless @silent
          @duplicated = @duplicated + 1
        else
          puts 'Create dividend failed with ', e unless @silent
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
