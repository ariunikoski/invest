class CreateLog < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :message
      t.boolean :displayed
      t.string :level

      t.timestamps
    end
  end
end
