module SectorBreakdown
  class Calculator
    def initialize(rates)
      @sectors = {}
      @rates = rates
      @grand_total = SectorBreakdown::Sector.new('Grand Total', @rates)
    end
    
    def get_sector(sector)
      @sectors[sector] = SectorBreakdown::Sector.new(sector, @rates) if !@sectors.include?(sector)
      @sectors[sector]
    end
    
    def load
      puts '>>> sector load @rates = ', @rates
      Share.all.order(:name).each do |share|
        sector = share.sector || 'undefined'
        sector_obj = get_sector(sector)
        sector_obj.add_share(share)
        @grand_total.add_share(share, true)
      end
      @sectors
    end
    
    def get_grand_total
      @grand_total
    end
  end
end