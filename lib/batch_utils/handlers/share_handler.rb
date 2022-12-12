class ShareHandler
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
    if name == @last_name || type != 'Share'
      puts 'Skipping...'
      return
    end
    @last_name = name
    share = Share.new
    share.name = name
    share.israeli_number = israeli_number
    share.currency = israeli_number == 'us' ? 'USD' : 'NIS'
    share.symbol = yahoo
    
    share.links << create_link('Yahoo', yahoo) unless yahoo.empty?
    share.links << create_link('Investing', investing) unless investing.empty?
    share.save
  end
end