class CreateHolders < ActiveRecord::Migration[7.0]
  def change
    create_table :holders do |t|
      t.text :name
      t.text :colour
      t.boolean :default

      t.timestamps
    end
  end
end
