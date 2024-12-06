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
  
  def get_amount_divider
    ['GBP', 'NIS'].include?(currency) ? 100 : 1
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
      total_div = total_div + div.amount
    end if stop_on
    
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
    today = Date.today
    earliest = today.prev_month(14)
    puts '>>> today, earliest', today, earliest
    stop_on = nil
    most_recent = nil
    divs = dividends.order(x_date: :desc)
    if divs.length > 0
      most_recent = divs.first.x_date
      puts '>>> most_recent', most_recent
      if most_recent < earliest
        puts '>>> exitting'
        return [nil, nil]
      end
      # go to the 1st day of the month following the last payment,
      # so if this month they paid on the 10th and last year this month on the 12th, it wont count both this year and last year
      # this resolves the rimoni bug 
      stop_on = most_recent.change(year: most_recent.year - 1, day: 1).advance(months: 1)
      puts '>>> stop_on', stop_on
      if stop_on < earliest
        puts '>>> resetting stop_on', name
        stop_on = earliest
        puts '>>> stop_on is now', stop_on
        #byebug
      end
    end
    [stop_on, most_recent]
  end 
 
  def projected_income
    projected = []
    return projected if holdings.length == 0 || dividends.length == 0
    stop_on, most_recent = get_stop_on
    t_holdings = total_holdings(false)
    first_day, last_day = get_date_range
    dividends.each do |div|
      break if div.x_date < stop_on
      last_date_considered = div.x_date
      amount = t_holdings * div.amount
      #projected_date = div.x_date.change(year: div.x_date.year + 1).advance(months: 1, day: day_advance)
      next_year = div.x_date >> 12
      projected_date = next_year.next_month
      projected << { projected_date: projected_date, amount: amount, share_name: name, share_symbol: symbol, currency: currency, type: :share, accounts: account_list } if projected_date >= first_day && projected_date <= last_day
    end
    projected
  end
  
  def get_most_recent_dividend
    # div_ytd[:most_recent]
    dividends.order(x_date: :desc).first&.x_date
  end
  
  def get_date_range
    today = Date.today
    first_of_next_month = Date.new(today.year, today.month, 1) >> 1
    last_of_current_month_next_year = (Date.new(today.year, today.month, 1) >> 13) - 1
    [first_of_next_month, last_of_current_month_next_year]
  end

  def account_list
    holdings.map{ |hh| hh.account}.uniq.sort.join(',')
  end
  
  def badges
    @badges ||= calc_badges
  end
  
  def calc_badges
    hold_badges = []
    
    puts '>>> div_ytd = ', div_ytd
    ytd = div_ytd
    last_date = ytd[:last_date]
    if last_date
      test_date = last_date.change(year: last_date.year + 1)
      hold_badges << :div_overdue if (test_date < Date.today)
    else
      hold_badges << :div_overdue
      hold_badges << :no_div_last_year 
    end
    
    if ytd[:ytd_pcnt] >= 7
      hold_badges << :really_good_price
    elsif ytd[:ytd_pcnt] >= 5
      hold_badges << :good_price
    end
    
    hold_badges << :under_performer if ytd[:weighted_ytd] < 4
    
    hold_badges << :comments if comments && comments.length > 0
    
    hold_badges << :big_investment if calc_nis_val >= 100000
    hold_badges
  end
  
  def calc_nis_val
    total_val = total_holdings * (current_price || 0)
    rc = Rates::RatesCache.instance
    rates = rc.get_rates
    rc.convert_to_nis(currency, total_val)
  end
  
  def dividends_by_year
    results = []
    current_year = nil
    amount = 0
    dividends.order(x_date: :desc).each do |dividend|
      yy = dividend.x_date.year
      puts '>>> current, divdate, divamount, yy, amount', current_year, dividend.x_date, dividend.amount, yy, amount
      if yy != current_year
        if current_year
          results << { year: current_year, amount: amount }
          amount = 0
        end
        current_year = yy
      end
      amount = amount + dividend.amount
    end
    if current_year && amount
      results << { year: current_year, amount: amount }
    end
    results
  end
  
  def p_l
    unless @p_l
      cost, total_holdings, missing_cost_count = total_cost_and_holdings
      profit = total_holdings * current_price - cost
      @p_l = [profit, missing_cost_count, (profit*100)/cost]
    end
    @p_l
  end
  
  def p_l_nis
    profit, missing, pcnt = p_l
    Rates::RatesCache.instance.convert_to_nis(currency, profit)
  end
  
  def p_l_pcnt
    profit, missing, pcnt = p_l
    pcnt
  end
  
  def total_cost_and_holdings
    avg_cost = calc_avg_cost
    total_cost = 0
    total_holdings = 0
    missing_cost_count = 0
    holdings.each do |holding|
      missing_cost_count = missing_cost_count + 1 if !holding.cost
      price = holding.cost || avg_cost
      total_cost = total_cost + price * holding.amount
      total_holdings = total_holdings + holding.amount
    end
    [total_cost, total_holdings, missing_cost_count]
  end
  
  def calc_avg_cost
    total_known_cost = 0
    total_known_cost_holdings = 0
    holdings.each do |holding|
      if holding.cost
        total_known_cost = total_known_cost + holding.cost * holding.amount
        total_known_cost_holdings = total_known_cost_holdings + holding.amount
      end
    end
    total_known_cost_holdings != 0 ? total_known_cost / total_known_cost_holdings : 0
  end
end
