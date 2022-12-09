
class CreateShares < ActiveRecord::Migration[7.0]
  def change
    create_table :shares do |t|
      t.string :name
      t.string :symbol
      t.integer :israeli_number
      t.string :currency
      t.decimal :last_dividend_trailing_pcnt
      t.decimal :current_price

      t.timestamps
    end
  end
end
