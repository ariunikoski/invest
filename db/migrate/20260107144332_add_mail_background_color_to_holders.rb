class AddMailBackgroundColorToHolders < ActiveRecord::Migration[7.0]
  def change
    add_column :holders, :mail_background_color, :string

    execute <<~SQL
      UPDATE holders
      SET mail_background_color = 'honeydew'
      WHERE name = 'ari'
    SQL

    execute <<~SQL
      UPDATE holders
      SET mail_background_color = 'bisque'
      WHERE name = 'jack'
    SQL
  end
end
