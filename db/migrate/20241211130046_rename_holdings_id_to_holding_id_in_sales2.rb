class RenameHoldingsIdToHoldingIdInSales2 < ActiveRecord::Migration[7.0]
  def change
    rename_column :sales, :holdings_id, :holding_id
  end
end
