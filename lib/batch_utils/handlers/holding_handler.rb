class HoldingHandler
  
  def handle_line(name, israeli_number, type, account, purchase_value, quantity, currency, yahoo, investing)
    obj = (type == 'Share') ? Share.find_by(name: name) : Fund.find_by(name: name)
    if (!obj) 
		puts "Could not find #{type} called #{name}"
		return
	end
	holding = Holding.new
	holding.amount = quantity
	holding.cost = purchase_value
	holding.account = account
	obj.holdings << holding
	obj.save
  end
end