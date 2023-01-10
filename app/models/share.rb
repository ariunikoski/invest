class Share < ApplicationRecord
  has_many :links, as: :linked_to, dependent: :destroy
  has_many :holdings, as: :held_by, dependent: :destroy
  has_many :dividends, dependent: :destroy
  
  # next steps
  # - div_ytd rturn @div_ytd |= calculate_div_ytd
  # - display data....
  # - preloading
  def calculate_div_ytd
    total_div = 0
    total_holdings = 0
    total_cost = 0
    sum_of_costs = 0
    most_recent = dividends.first.x_date
    stop_before = most_recent.change(year: most_recent.year - 1)
    last_date_considered = nil
    total_pcnt = 0
    puts '>>> most_recent, stop_before', most_recent, stop_before
    dividends.each do |div|
      puts '>>> now checking: ', div.x_date
      break if div.x_date <= stop_before
      puts '>>> handling it...'
      last_date_considered = div.x_date
      total_div = total_div + div.amount
    end
    
    holdings.each do |holding|
      puts '>>> holding', holding.amount, holding.cost
      total_holdings = total_holdings + holding.amount
      total_cost = holding.amount * holding.cost + total_cost
      earning = holding.amount * total_div
      pcnt = earning * 100 / holding.cost
      total_pcnt = total_pcnt + pcnt
      sum_of_costs = sum_of_costs + holding.cost
    end
    
    yearly_earnings = total_div * total_holdings 
    
    avg_cost = sum_of_costs / holdings.length
    avg_pcnt = yearly_earnings * 100 / (avg_cost * total_holdings)
    
    weighted_cost = total_cost / total_holdings
    weighted_pcnt = yearly_earnings *100 / (weighted_cost * total_holdings)
    
    current_pcnt = yearly_earnings * 100 / (current_price * total_holdings)
    
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
