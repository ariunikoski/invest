class CreateExchangeRate < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_rates do |t|
      t.string :currency_code
      t.decimal :exchange_rate, precision: 15, :scale => 2
      t.timestamps
    end
  end
end
