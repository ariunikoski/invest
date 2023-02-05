module SectorBreakdown
  class Sector
    def initialize(name)
      @industries = {}
      @totals = SectorBreakdown::Industry.new
      @name = name
    end
    
    def add_share(share, use_grand_total = false)
      amount = share.total_holdings * share.current_price / share.get_amount_divider
      industry = share.industry || 'undefined'
      industry = 'Grand Total' if use_grand_total
      get_industry(industry).add_amount(share.currency, amount)
      @totals.add_amount(share.currency, amount)
    end
    
    def get_industry(industry)
      @industries[industry] = SectorBreakdown::Industry.new if !@industries.include?(industry)
      @industries[industry]
    end
  end
end