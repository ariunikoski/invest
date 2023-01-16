class Share < ApplicationRecord
  has_many :links, as: :linked_to, dependent: :destroy
  has_many :holdings, as: :held_by, dependent: :destroy
  has_many :dividends, dependent: :destroy
  
  def total_holdings(by_account = false, account = nil)
    by_account ? holdings.where(account: account).sum(:amount) : holdings.sum(:amount)
  end
  
  def div_ytd
    @div_ytd ||= calculate_div_ytd
  end
  
  def calculate_div_ytd
    total_div = 0
    total_holdings = 0
    total_cost = 0
    sum_of_costs = 0
    stop_before = nil
    stop_on, most_recent = get_stop_on
    last_date_considered = nil
    total_pcnt = 0
    dividends.each do |div|
      break if div.x_date < stop_on
      last_date_considered = div.x_date
      puts '>>> last_date_considered = ', last_date_considered
      total_div = total_div + div.amount
    end
    
    puts '>>> after loop last_date_considered = ', last_date_considered
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
    
    puts '>>> before cinstuction last_date_considered = ', last_date_considered
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
 
  def get_stop_on
    stop_on = nil
    most_recent = nil
    if dividends.length > 0
      most_recent = dividends.first.x_date
      # go to the 1st day of the month following the last payment,
      # so if this month they paid on the 10th and last year this month on the 12th, it wont count both this year and last year
      # this resolves the rimoni bug 
      stop_on = most_recent.change(year: most_recent.year - 1, day: 1).advance(months: 1)
    end
    [stop_on, most_recent]
  end 
 
  def projected_income
    projected = []
    return projected if holdings.length == 0 || dividends.length == 0
    stop_on = get_stop_on
    t_holdings = total_holdings(false)
    dividends.each do |div|
      break if div.x_date < stop_on
      last_date_considered = div.x_date
      amount = t_holdings * div.amount
      projected_date = div.x_date.change(year: div.x_date.year + 1).advance(months: 1)
      projected << { projected_date: projected_date, amount: amount, share_name: name, share_symbol: symbol, currency: currency, type: :share }
    end
    projected
  end
  
  def badges
    @badges ||= calc_badges
  end
  
  def calc_badges
    hold_badges = []
    ytd = div_ytd
    puts '>>> ytd = ', ytd
    last_date = ytd[:last_date]
    if last_date
      test_date = last_date.change(yy: last_date.year + 1)
      hold_badges << :div_overdue if (test_date < Date.new)
    end
    if ytd[:ytd_pcnt] >= 7
      hold_badges << :really_good_price
    elsif ytd[:ytd_pcnt] >= 5
      hold_badges << :good_price
    end
    hold_badges << :under_performer if ytd[:weighted_ytd] < 4
    hold_badges
  end
end
