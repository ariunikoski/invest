class AddMultiCurrencyToHolders < ActiveRecord::Migration[7.0]
  def change
   add_column :holders, :multi_currency, :boolean, default: true, null: false

    execute <<~SQL
      UPDATE holders
      SET multi_currency = FALSE
      WHERE name = 'jack'
    SQL
  end
end
