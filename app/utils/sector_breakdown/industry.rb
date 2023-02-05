module SectorBreakdown
  class Industry
    def initialize
      @currencies = {}
    end
    
    def add_amount(currency, amount)
      @currencies[currency] = 0 if !@currencies.include?(currency)
      @currencies[currency] = amount + @currencies[currency]
    end
    
    def get_currencies
      @currencies
    end
  end
end