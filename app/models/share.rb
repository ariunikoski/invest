class Share < ApplicationRecord
  has_many :links, as: :linked_to, dependent: :destroy
  has_many :holdings, as: :held_by, dependent: :destroy
  has_many :dividends, dependent: :destroy
  
  def div_ytd
    @div_ytd ||= calculate_div_ytd
  end
  
  def calculate_div_ytd
    total_div = 0
    total_holdings = 0
    total_cost = 0
    sum_of_costs = 0
    most_recent = nil
    stop_before = nil
    if dividends.length > 0
      most_recent = dividends.first.x_date
      # go to the 1st day of the month following the last payment,
      # so if this month they paid on the 10th and last year this month on the 12th, it wont count both this year and last year
      # this resolves the rimoni bug 
      stop_on = most_recent.change(year: most_recent.year - 1, day: 1).advance(months: 1)
    end
    last_date_considered = nil
    total_pcnt = 0
    dividends.each do |div|
      break if div.x_date < stop_on
      last_date_considered = div.x_date
      total_div = total_div + div.amount
    end
    
    holdings.each do |holding|
      total_holdings = total_holdings + holding.amount
      total_cost = (holding.amount || 0) * (holding.cost || 0) + total_cost
      earning = holding.amount * total_div
      pcnt = earning * 100 / (holding.cost || 0)
      total_pcnt = total_pcnt + pcnt
      sum_of_costs = sum_of_costs + (holding.cost || 0)
    end
    
    yearly_earnings = total_div * total_holdings 
    
    avg_cost = 0
    avg_pcnt = 0
    weighted_cost = 0
    weighted_pcnt = 0
    if (holdings.length > 0)
      avg_cost = sum_of_costs / holdings.length
      avg_pcnt = yearly_earnings * 100 / (avg_cost * total_holdings)
    
      weighted_cost = total_cost / total_holdings
      weighted_pcnt = yearly_earnings *100 / (weighted_cost * total_holdings)
    end
    
    price = current_price || 0
    current_pcnt = price > 0 ? yearly_earnings * 100 / (price * total_holdings) : 0
    
    puts '>>> yearkly_earnings', yearly_earnings
    puts '>>> total holdings', total_holdings
    puts '>>> total cost', total_cost
    {
	  most_recent: most_recent,
	  last_date: last_date_considered,
	  yearly_earnings: yearly_earnings,
	  ytd_pcnt: current_pcnt,
	  avg_cost: avg_cost,
	  avg_ytd: avg_pcnt,
	  weighted_cost: weighted_cost,
	  weighted_ytd: weighted_pcnt
	}
  end
end
