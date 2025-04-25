require 'spec_helper'
require 'div_analyzer/analyzer'

RSpec.describe DivAnalyzer::Analyzer do
  describe 'initialization' do
    it 'should handle 15/6/24' do
      dates = DivAnalyzer::Analyzer.new(Date.new(2024, 6, 15)).get_dates
      expect(dates[:end_period_a]).to eql Date.new(2024, 5, 31)
      expect(dates[:start_period_a]).to eql Date.new(2023, 6, 1)
    end

    it 'should handle 15/3/24' do
      dates = DivAnalyzer::Analyzer.new(Date.new(2024, 3, 15)).get_dates
      expect(dates[:end_period_a]).to eql Date.new(2024, 2, 29)
      expect(dates[:start_period_a]).to eql Date.new(2023, 3, 1)
    end

    it 'should handle 15/3/25' do
      dates = DivAnalyzer::Analyzer.new(Date.new(2025, 3, 15)).get_dates
      expect(dates[:end_period_a]).to eql Date.new(2025, 2, 28)
      expect(dates[:start_period_a]).to eql Date.new(2024, 3, 1)
    end

    it 'should handle 15/1/25' do
      dates = DivAnalyzer::Analyzer.new(Date.new(2025, 1, 15)).get_dates
      expect(dates[:end_period_a]).to eql Date.new(2024, 12, 31)
      expect(dates[:start_period_a]).to eql Date.new(2024, 1, 1)
    end
  end
  
  describe 'add_div' do
    before :each do
      @anal = DivAnalyzer::Analyzer.new(Date.new(2025, 1, 15))
    end
 
    it 'a date before the range' do
      retval = @anal.add_div(Date.new(2025, 1, 2), 10) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [0, 0]
      expect(@anal.get_pcnt).to eql 0
    end
 
    it 'a date inside the a range - extreme end' do
      retval = @anal.add_div(@anal.get_dates[:end_period_a], 12) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [12, 0]
      expect(@anal.get_pcnt).to eql 100
    end
 
    it 'a date inside the a range - middle' do
      retval = @anal.add_div(@anal.get_dates[:end_period_a] - 5, 13) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [13, 0]
      expect(@anal.get_pcnt).to eql 100
    end
 
    it 'a date inside the a range - extreme start' do
      retval = @anal.add_div(@anal.get_dates[:start_period_a], 14) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [14, 0]
      expect(@anal.get_pcnt).to eql 100
    end
    
    it 'a date inside the b range - extreme end' do
      retval = @anal.add_div(@anal.get_dates[:end_period_b], 15) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [0, 15]
      expect(@anal.get_pcnt).to eql -100
    end
 
    it 'a date inside the b range - middle' do
      retval = @anal.add_div(@anal.get_dates[:end_period_b] - 5, 16) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [0, 16]
      expect(@anal.get_pcnt).to eql -100
    end
 
    it 'a date inside the b range - extreme start' do
      retval = @anal.add_div(@anal.get_dates[:start_period_b], 17) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [0, 17]
      expect(@anal.get_pcnt).to eql -100
    end
    
    it 'past the far end' do
      retval = @anal.add_div(@anal.get_dates[:start_period_b] - 5, 18) 
      expect(retval).to eql false
      expect(@anal.get_totals).to eql [0, 0]
      expect(@anal.get_pcnt).to eql 0
    end
 
    it 'both dates' do
      retval = @anal.add_div(@anal.get_dates[:start_period_a], 240) 
      expect(retval).to eql true
      retval = @anal.add_div(@anal.get_dates[:start_period_b], 200) 
      expect(retval).to eql true
      expect(@anal.get_totals).to eql [240, 200]
      expect(@anal.get_pcnt).to eql 20
    end
    
  end
end