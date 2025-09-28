class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :value, null: false
      t.string :device_name
      t.string :ip_address
      t.string :user_agent
      t.datetime :last_used_at
      t.timestamps
    end

    add_index :tokens, :value, unique: true
  end
end
