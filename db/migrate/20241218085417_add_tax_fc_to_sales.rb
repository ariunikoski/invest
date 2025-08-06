class AddTaxFcToSales < ActiveRecord::Migration[7.0]
  def change
    add_column :sales, :tax_fc, :decimal, precision: 10, scale: 2
  end
end
