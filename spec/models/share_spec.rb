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
  end
  
  describe 'p_l' do
    it 'calculates the profit or loss correctly' do
      allow(@share).to receive(:total_cost_and_holdings).and_return [400, 4, 3]
      allow(@share).to receive(:current_price).and_return 110
      expect(@share.p_l).to eq([40, 3])
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