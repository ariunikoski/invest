module SectorBreakdown
  class Industry
    def initialize(rates)
      @currencies = {}
      @currencies['TOT_NIS'] = 0
      @rates = rates
      puts '>>> industry init', rates
    end
    
    def add_amount(currency, amount)
      puts '>>> @rates = ', @rates, ' currency = ', currency, 'amount = ', amount, 'kiil', '###', @currencies
      @currencies[currency] = 0 if !@currencies.include?(currency)
      @currencies[currency] = amount + @currencies[currency]
      apply_rate = (currency == 'NIS') ? 1.0 : @rates[currency]
      @currencies['TOT_NIS'] = amount * apply_rate + @currencies['TOT_NIS']
    end
    
    def get_currencies
      @currencies
    end
  end
end