class AddAmountSoldToHoldings < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :amount_sold, :integer
  end
end
