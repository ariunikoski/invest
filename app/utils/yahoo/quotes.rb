module Yahoo
  require 'rest-client'
  class Quotes
    def initialize
      @symbols = Share.all.map { |share| share.symbol }.join(',')
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
        return
      end
      if response.code != 200
        puts "Failed to get data for: #{@symbols} with #{response.code}"
        return
      end
      if !response.body.empty?
        data = JSON.parse(response.body)
        handle_quotes(data['quoteResponse']['result'])
        puts 'finito'
      end
    end
    
    def handle_quotes(quotes)
      quotes.each do |quote|
        handle_quote quote
      end
    end
    
    def handle_quote quote
      symbol = quote['symbol']
      value = quote['regularMarketPrice']
      puts "Now handling: #{symbol} #{value}"
      share = Share.find_by(symbol: symbol)
      if share
        share.current_price = value
        share.save
      else
        puts "Failed to find share for symbol #{symbol}"
      end
    end
  end
end