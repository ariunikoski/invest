module SectorBreakdown
  class Industry
    def initialize(rates)
      @currencies = {}
      @currencies['TOT_NIS'] = 0
      @rates = rates
      @shares = []
    end
    
    def add_amount(share)
      currency = share.currency
      begin
        amount = share.total_holdings * share.current_price / share.get_amount_divider
      rescue => e
        amount = 0
      end
      @currencies[currency] = 0 if !@currencies.include?(currency)
      @currencies[currency] = amount + @currencies[currency]
      apply_rate = (currency == 'NIS') ? 1.0 : @rates[currency]
      @currencies['TOT_NIS'] = amount * apply_rate + @currencies['TOT_NIS']
      @shares << share
    end
    
    def get_currencies
      @currencies
    end
    
    def get_shares
      @shares
    end
  end
end