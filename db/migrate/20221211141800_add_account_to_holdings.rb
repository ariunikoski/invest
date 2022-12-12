
class AddAccountToHoldings < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :account, :string
  end
end
