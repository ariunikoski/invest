class ShareHandler
  def initialize()
    @last_name = ''
  end
  
  def handle_line(name, israeli_number, type, account, purchase_value, quantity, currency, yahoo, investing)
    if name == @last_name
      puts 'Skipping...'
    end
  end
end