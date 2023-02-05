module Yahoo
  require 'rest-client'
  class Summary
    def initialize(share)
      @share = share
      @symbol = share.symbol
    end
    
    def load
      begin
        params = {'symbol': @symbol, 'region': 'US'}
        response =  RestClient.get("https://yh-finance.p.rapidapi.com/stock/v2/get-summary", {
		  'content_type': 'json',
		  'accept': 'json', 
          'X-RapidAPI-Key': 'cefb88ea18msh5dc12cef89546d2p10de4bjsne8e995c4b445',
          'X-RapidAPI-Host': 'yh-finance.p.rapidapi.com',
          'params': params
        })
      rescue => e
        puts "Summary - Failed to get data for: #{@symbol}, with #{e}"
        return
      end
      if response.code != 200
        puts "Summary - Failed to get data for: #{@symbol}, with #{response.code}"
        return
      end
      if !response.body.empty?
        data = JSON.parse(response.body)
        #puts '>>> response', response.body
        sp = data['summaryProfile']
        industry = sp['industry']
        sector = sp['sector']
        longBusinessSummary = sp['longBusinessSummary']
        puts '>>> got ', sector, industry, longBusinessSummary
        @share.sector = sector
        @share.industry = industry
        @share.yahoo_summary = longBusinessSummary
        @share.save!
      end
    end
  end
end