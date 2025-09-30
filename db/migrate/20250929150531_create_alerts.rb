class CreateAlerts < ActiveRecord::Migration[7.0]
  def change
    create_table :alerts do |t|
      t.references :share, null: false, foreign_key: true
      t.string :alert_type
      t.string :alert_status
      t.date :ignore_until

      t.timestamps
    end
  end
end
