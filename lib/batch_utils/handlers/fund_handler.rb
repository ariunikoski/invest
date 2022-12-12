class FundHandler
  def initialize()
    @last_name = ''
  end
  
  def create_link(lname, lval)
    url = lname == 'Yahoo' ? "https://finance.yahoo.com/quote/#{lval}/history?p=#{lval}" :
    "https://www.investing.com/equities/#{lval}-dividends"
    link = Link.new
    link.name = lname
    link.target_url = url
    link
  end
  
  def handle_line(name, israeli_number, type, account, purchase_value, quantity, currency, yahoo, investing)
    if name == @last_name || type != 'Fund'
      puts 'Skipping...'
      return
    end
    @last_name = name
    fund = Fund.new
    fund.name = name
    fund.israeli_number = israeli_number
    fund.currency = israeli_number == 'us' ? 'USD' : 'NIS'
    fund.symbol = yahoo
    
    fund.links << create_link('Yahoo', yahoo) unless yahoo.empty?
    fund.links << create_link('Investing', investing) unless investing.empty?
    fund.save
  end
end