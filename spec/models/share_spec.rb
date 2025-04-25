require 'rails_helper'

RSpec.describe Share, type: :model do
  # Sample data setup

  before :each do
    @share = Share.new
    h1 = Holding.new(cost: 10, amount: 20)
    h2 = Holding.new(cost: 20, amount: 25)
    h3 = Holding.new(amount: 2)
    @h12 = [h1, h2]
    @h123 = [h1, h2, h3]
    # in the following I use integers for x_date. It should be dates but for testing
    # purposes integers are easier and just as good...
    @d1 = Dividend.new(x_date: 200, amount: 5)
    @d2 = Dividend.new(x_date: 100, amount: 3)
    @d3 = Dividend.new(x_date: 50, amount: 7)
    @d123 = [@d1, @d2, @d3]
  end
  
  describe 'get_div_anaylzer' do
    it 'should return whatever if already defined' do
      @share.instance_variable_set(:@div_analyzer, 'whatever')
      expect(@share.get_div_analyzer).to eql 'whatever'
    end
    
    it 'handle multiple divs' do
      allow(Date).to receive(:today).and_return(Date.new(2025, 1, 22))
      divs = []
      divs << Dividend.new(x_date: Date.today, amount: 77)
      divs << Dividend.new(x_date: Date.new(2024, 12, 10), amount: 40)
      divs << Dividend.new(x_date: Date.new(2024, 11, 10), amount: 120)
      divs << Dividend.new(x_date: Date.new(2023, 11, 10), amount: 200)
      divs << Dividend.new(x_date: Date.new(2022, 11, 10), amount: 88)
      divs << Dividend.new(x_date: Date.new(2021, 11, 10), amount: 99)
      allow(@share).to receive(:dividends).and_return divs
      da = @share.get_div_analyzer
      expect(da.get_totals).to eql [160, 200]
      expect(da.get_pcnt).to eql -20
    end
  end
  
  describe 'div_anal' do
    it '50 should return :div_up_25' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return 50
      expect(@share.div_anal).to eql :div_up_25
    end
  
    it '25 should return :div_up_25' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return 25
      expect(@share.div_anal).to eql :div_up_25
    end
  
    it '24 should return :div_up' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return 24
      expect(@share.div_anal).to eql :div_up
    end
  
    it '-50 should return :div_down_25' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return -50
      expect(@share.div_anal).to eql :div_down_25
    end
  
    it '-25 should return :div_down_25' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return -25
      expect(@share.div_anal).to eql :div_down_25
    end
  
    it '-24 should return :div_down' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return -24
      expect(@share.div_anal).to eql :div_down
    end
  
    it '0 should return nil' do
      allow(@share).to receive_message_chain(:get_div_analyzer, :get_pcnt).and_return 0
      expect(@share.div_anal).to eql nil
    end
  end
  
  describe 'get_stop_on' do
    before :each do
      allow(Date).to receive(:today).and_return(Date.new(2024, 2, 22))
      @dd1 = Dividend.new(x_date: Date.new(2024, 2, 20))
    end
    
    it 'when earliest is not invoked' do
      allow(@share).to receive_message_chain(:dividends, :order).and_return [@dd1]
      stop_on, most_recent = @share.get_stop_on
      dates_equal = stop_on == Date.new(2023, 3, 1)
      expect(dates_equal).to eql true
    end
    
    it 'when earliest is invoked' do
      allow(Date).to receive(:today).and_return(Date.new(2024, 6, 22))
      allow(@share).to receive_message_chain(:dividends, :order).and_return [@dd1]
      stop_on, most_recent = @share.get_stop_on
      dates_equal = stop_on == Date.new(2023, 4, 22)
      expect(dates_equal).to eql true
    end
    
    it 'when no dividends' do
      allow(@share).to receive_message_chain(:dividends, :order).and_return []
      stop_on, most_recent = @share.get_stop_on
      expect(stop_on).to eql nil
      expect(most_recent).to eql nil
    end
    
    it 'when most recent is beyond the pale' do
      allow(Date).to receive(:today).and_return(Date.new(2025, 6, 22))
      allow(@share).to receive_message_chain(:dividends, :order).and_return [@dd1]
      stop_on, most_recent = @share.get_stop_on
      expect(stop_on).to eql nil
      expect(most_recent).to eql nil
    end
  end
  
  describe 'calculate_div_ytd' do
    before :each do
      allow(@share).to receive(:holdings).and_return @h12
      allow(@share).to receive(:dividends).and_return @d123
      allow(@share).to receive(:current_price).and_return 200
      allow(@share).to receive(:get_stop_on).and_return [70, 200]
    end

    it 'with holdings' do
      yy = @share.calculate_div_ytd
      expect(yy[:ytd_pcnt]).to eql 4
      expect(yy[:most_recent]).to eql 200
      expect(yy[:last_date]).to eql 100
      expect(yy[:yearly_earnings]).to eql 360
      expect(yy[:avg_cost].round(2)).to eql 15.56
      expect(yy[:avg_ytd].round(2)).to eql 51.43
      expect(yy[:weighted_cost].round(2)).to eql 15.56
      expect(yy[:weighted_ytd].round(2)).to eql 51.43
    end

    it 'with holdings including unknown cost' do
      allow(@share).to receive(:holdings).and_return @h123
      yy = @share.calculate_div_ytd
      expect(yy[:ytd_pcnt]).to eql 4
      expect(yy[:most_recent]).to eql 200
      expect(yy[:last_date]).to eql 100
      expect(yy[:yearly_earnings]).to eql 376
      expect(yy[:avg_cost].round(2)).to eql 15.56
      expect(yy[:avg_ytd].round(2)).to eql 51.43
      expect(yy[:weighted_cost].round(2)).to eql 15.56
      expect(yy[:weighted_ytd].round(2)).to eql 51.43
    end

    it 'with no holdings' do
      allow(@share).to receive(:holdings).and_return []
      yy = @share.calculate_div_ytd
      expect(yy[:ytd_pcnt]).to eql 4
      expect(yy[:most_recent]).to eql 200
      expect(yy[:last_date]).to eql 100
      expect(yy[:yearly_earnings]).to eql 0
      expect(yy[:avg_cost].round(2)).to eql 0
      expect(yy[:avg_ytd].round(2)).to eql 0
      expect(yy[:weighted_cost].round(2)).to eql 0
      expect(yy[:weighted_ytd].round(2)).to eql 0
    end
  end
  
  describe 'p_l' do
    it 'calculates the profit or loss correctly' do
      allow(@share).to receive(:total_cost_and_holdings).and_return [400, 4, 3]
      allow(@share).to receive(:current_price).and_return 110
      expect(@share.p_l).to eq([40, 3, 10])
    end
  end

  describe 'total_cost_and_holdings' do
    before :each do
      allow(@share).to receive(:calc_avg_cost).and_return 15
    end

    it 'when all holdings have costs' do
      allow(@share).to receive(:holdings).and_return @h12
      expect(@share.total_cost_and_holdings).to eql([700, 45, 0])
    end

    it 'when not all holdings have costs' do
      allow(@share).to receive(:holdings).and_return @h123
      expect(@share.total_cost_and_holdings).to eql([730, 47, 1])
    end
  end

  describe 'calc_avg_cost' do
    it 'calculates the average when all have cost' do
      allow(@share).to receive(:holdings).and_return @h12
      received = @share.calc_avg_cost.round(2)
      expected = (700.0/45).round(2)
      expect(received).to eql expected
    end

    it 'calculates the average when not all have cost' do
      allow(@share).to receive(:holdings).and_return @h123
      received = @share.calc_avg_cost.round(2)
      expected = (700.0/45).round(2)
      expect(received).to eql expected
    end

    it 'calculates the average when no holdings' do
      allow(@share).to receive(:holdings).and_return []
      received = @share.calc_avg_cost.round(2)
      expect(received).to eql 0
    end
  end
end