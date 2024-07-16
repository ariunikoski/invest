require 'singleton'

module Rates
  class RatesCache
    include Singleton

    def initialize
      @rates = {}
    end

    def get_rates
      load_rates if @rates.empty?
      @rates
    end

    def load_rates
      ExchangeRate.all.each do |rate|
        @rates[rate.currency_code] = rate.exchange_rate
      end
    end
  
    def clear_rates
      @rates.clear
    end
  
    def convert_to_nis(currency_code, amount)
      converted = currency_code == 'NIS' ? amount  || 0 : (@rates[currency_code] || 0) * (amount || 0)
      div_by_100?(currency_code) ? converted/100 : converted
    end
  
    def div_by_100?(currency_code)
      currency_code == 'NIS' || currency_code == 'GBP'
    end
end #class
end #module
