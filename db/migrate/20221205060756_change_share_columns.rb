
class ChangeShareColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :shares do |t|
      t.change :last_dividend_trailing_pcnt, :decimal, :precision => 5, :scale => 2
      t.change :current_price, :decimal, :precision => 15, :scale => 2
    end
  end
end
