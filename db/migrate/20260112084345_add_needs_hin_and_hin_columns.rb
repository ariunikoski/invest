class AddNeedsHinAndHinColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :holders, :needs_hin, :boolean, default: false, null: false

    # 2) Update existing holder named "jack"
    execute <<~SQL
      UPDATE holders
      SET needs_hin = TRUE
      WHERE name = 'jack'
    SQL

    # 3) Add varchar (string) column to holdings
    add_column :holdings, :hin, :string
  end
end
