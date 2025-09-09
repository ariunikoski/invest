module BatchUtils
require './lib/batch_utils/handlers/share_handler.rb'
require './lib/batch_utils/handlers/fund_handler.rb'
require './lib/batch_utils/handlers/holding_handler.rb'
class LoadSharesFunds
  def initialize filename
    puts 'Ready to load ' + filename
    @filename = filename
  end

  def remove_leading_trailing(inval, remchar)
    inval.chomp(remchar).reverse.chomp(remchar).reverse
  end

  def import_holdings
    handle_file(HoldingHandler.new)
  end

  def import_funds
    handle_file(FundHandler.new)
  end

  def import_shares
    handle_file(ShareHandler.new)
  end
  
  def handle_file handler
    puts 'Now loading ' + @filename
    File.foreach(@filename) do |line|
      #puts 'Handling ' + line
      oawk = line.force_encoding("iso-8859-1").split("\t")
      awk = []
      oawk.each do |ee|
        eee = remove_leading_trailing(ee, '"')
        awk << remove_leading_trailing(eee, ' ')
      end

      name = awk[0]
      next if name.empty?

      israeli_number = awk[1]
      type = awk[2]
      account = awk[3]
      purchase_value = awk[4]
      quantity = awk[5]
      currency = awk[7]
      yahoo = awk[26]
      investing = awk[27]
      puts "name = #{name} account=#{account} israeli_number = #{israeli_number} type = #{type} purchase_value=#{purchase_value} quantity=#{quantity} currency=#{currency} yahoo=#{yahoo} investing = #{investing}"

      handler.handle_line(name, israeli_number, type, account, purchase_value, quantity, currency, yahoo, investing)
    end
  end
end
end


