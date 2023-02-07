module SectorBreakdown
  class Sector
    def initialize(name, rates)
      puts '>>> sector initialize: ', rates
      @industries = {}
      @totals = SectorBreakdown::Industry.new(rates)
      @name = name
      @rates = rates
    end
    
    def add_share(share, use_grand_total = false)
      amount = share.total_holdings * share.current_price / share.get_amount_divider
      industry = share.industry || 'undefined'
      industry = 'Grand Total' if use_grand_total
      get_industry(industry).add_amount(share.currency, amount)
      @totals.add_amount(share.currency, amount)
    end
    
    def get_industry(industry)
      @industries[industry] = SectorBreakdown::Industry.new(@rates) if !@industries.include?(industry)
      @industries[industry]
    end
    
    def get_industries
      @industries
    end
    
    def get_totals
      @totals
    end
  end
end