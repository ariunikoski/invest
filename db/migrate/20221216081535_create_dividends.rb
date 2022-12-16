class CreateDividends < ActiveRecord::Migration[7.0]
  def change
    create_table :dividends do |t|
      t.references :share, null: false, foreign_key: true
      t.date :x_date
      t.date :payment_date
      t.decimal :amount, precision: 15, :scale => 2

      t.timestamps
    end
  end
end
