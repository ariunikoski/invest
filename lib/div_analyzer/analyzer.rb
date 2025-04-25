require 'date'
module DivAnalyzer
  class Analyzer
    def initialize(before_date)
      @end_period_a = last_day_of_previous_month(before_date)
      @start_period_a = start_of_year(@end_period_a)
      @end_period_b = last_day_of_previous_month(@start_period_a)
      @start_period_b = start_of_year(@end_period_b)
      @total_div_a = 0
      @total_div_b = 0
    end
    

    def last_day_of_previous_month(date)
      first_day = Date.new(date.year, date.month, 1)
      first_day - 1
    end
    
    def start_of_year(date)
      next_day = date + 1
      Date.new(next_day.year - 1, next_day.month, next_day.day)
    end
    
    def get_dates
      {
		end_period_a: @end_period_a,
		start_period_a: @start_period_a,
		end_period_b: @end_period_b,
		start_period_b: @start_period_b
      }	
    end
    
    def add_div(date, amount)
      return true if date > @end_period_a
      if date >= @start_period_a
        @total_div_a = @total_div_a + amount
        return true
      end
      if date >= @start_period_b
        @total_div_b = @total_div_b + amount
        return true
      end
      return false
    end
    
    def get_totals
      [@total_div_a, @total_div_b]
    end
    
    def get_pcnt
      return (@total_div_a == 0 ? 0 : 100) if @total_div_b == 0
      @total_div_b != 0 ? ((@total_div_a - @total_div_b) * 100)/@total_div_b : 100
    end
  end
end
