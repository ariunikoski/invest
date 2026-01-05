module CurrencyConverter
  require 'rest-client'
  class LoadAllCurrencies
    def load(silent = false)
      oer = OpenExchangeRates.new(silent)
      rates = ExchangeRate.all
      rates.each do |rate|
        puts 'Now doing ' + rate.currency_code unless silent
        er = oer.get_rate(rate.currency_code)
        if er
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