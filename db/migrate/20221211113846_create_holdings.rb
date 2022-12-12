class CreateHoldings < ActiveRecord::Migration[7.0]
  def change
    create_table :holdings do |t|
      t.references :held_by, polymorphic: true, null: false
      t.date :purchase_date
      t.integer :amount
      t.decimal :cost, :precision => 15, :scale => 2

      t.timestamps
    end
  end
end
