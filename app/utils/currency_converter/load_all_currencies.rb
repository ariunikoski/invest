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
          rate.exchange_rate = er
          rate.save
        end
      end
    end
  end
end