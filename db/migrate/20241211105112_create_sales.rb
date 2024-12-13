class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.references :shares, null: false, foreign_key: true
      t.references :holdings, null: false, foreign_key: true
      t.date :sale_date
      t.integer :amount
      t.decimal :sale_price, precision: 10, scale: 2
      t.decimal :tax_nis, precision: 10, scale: 2
      t.decimal :service_fee_nis, precision: 10, scale: 2
      t.decimal :service_fee_fc, precision: 10, scale: 2

      t.timestamps
    end
  end
end
