module CurrencyConverter
  require 'rest-client'
  class LoadAllCurrencies
    def load
      rates = ExchangeRate.all
      rates.each do |rate|
        puts 'Now doing ' + rate.currency_code
        cc = CurrencyConverter.new(rate.currency_code)
        er = cc.load
        if (er > 0)
          Log.info("Got rate for #{rate.currency_code} - setting it to #{er}")
          rate.exchange_rate = er
          rate.save
        else
          Log.warn("Failed to get rate for #{rate.currency_code}")
        end
      end
    end
  end
end