
class AddIndexToDuvidends < ActiveRecord::Migration[7.0]
  def change
    add_index :dividends, [:share_id, :x_date], unique: true
  end
end
