module Yahoo
  require 'rest-client'
  class Quotes
    def initialize
      @symbols_array = Share.all.map { |share| share.symbol }
      @symbols = @symbols_array.join(',')
      #@symbols = "WBD,T"
      puts "Ready to get quotes for #{@symbols}"
    end
 
 #const options = {
 # method: 'GET',
 # url: 'https://yh-finance.p.rapidapi.com/market/v2/get-quotes',
 # params: {region: 'US', symbols: 'CMA,IBM,T,SNEL.TA'},
 # headers: {
 #   'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
 #   'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com'
 # }
 #};

    def load
      Log.info("Commencing load of current values - #{@symbols.split(',').length} values to load")
      begin
        params = {'symbols': @symbols, 'region': 'US'}
        response =  RestClient.get("https://yh-finance.p.rapidapi.com/market/v2/get-quotes", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
          'params': params
        })
      rescue => e
        puts "Failed to get data for: #{@symbols} with #{e}"
        Log.error "Failed to get data for: #{@symbols} with #{e}"
        return
      end
      if response.code != 200
        puts "Failed to get data for: #{@symbols} with #{response.code}"
        Log.error "Failed to get data for: #{@symbols} with #{response.code}"
        return
      end
      if !response.body.empty?
        data = JSON.parse(response.body)
        handle_quotes(data['quoteResponse']['result'])
        redo_failures
        puts 'finito'
        Log.info("Successfully loaded")
      else
        puts 'Response body was empty'
      end
    end
    
    def handle_quotes(quotes)
      #puts '>>> handle_quotes calles with ', quotes
      @successfuls = []
      quotes.each do |quote|
        handle_quote quote
      end
      #puts ' >>> The following symbols were updated: ', @successfuls
    end
    
    def redo_failures
      failures = []
      Log.info("#{@successfuls.length} loaded")
      @symbols_array.each do |symbol|
        failures.push(symbol) if !@successfuls.include?(symbol)
      end
      failures_string = failures.join(',')
      puts 'The following failed to load: ', failures_string
      return if failures.length == 0
      if failures.length == @symbols_array.length
        Log.error("#{failures} could not be loaded")
        return
      end
      puts 'Going to try again'
      Log.warn("#{failures.length} not loaded - going to try again")
      @symbols_array = failures
      @symbols = failures_string
      load
    end
    
    def handle_quote quote
      #puts '>>> handle_quote called with ', quote
      symbol = quote['symbol']
      value = quote['regularMarketPrice']
      puts "Now handling: #{symbol} #{value}"
      share = Share.find_by(symbol: symbol)
      if share
        @successfuls.push(symbol)
        share.current_price = value
        share.save
      else
        puts "Failed to find share for symbol #{symbol}"
      end
    end
  end
end