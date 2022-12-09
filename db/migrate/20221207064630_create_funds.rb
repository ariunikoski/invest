class CreateFunds < ActiveRecord::Migration[7.0]
  def change
    create_table :funds do |t|
      t.string :name
      t.string :symbol
      t.integer :israeli_number
      t.string :currency
      t.decimal :current_price, :precision => 15, :scale => 2
      t.timestamps
    end
  end
end
