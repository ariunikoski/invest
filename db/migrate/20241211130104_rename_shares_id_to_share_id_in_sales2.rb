class RenameSharesIdToShareIdInSales2 < ActiveRecord::Migration[7.0]
  def change
    rename_column :sales, :shares_id, :share_id
  end
end
