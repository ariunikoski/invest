class AddActiveToShares < ActiveRecord::Migration[7.0]
  def change
    add_column :shares, :active, :boolean, default: true, null: false

    # Ensure existing rows are true (safety in case DB doesn't backfill)
    reversible do |dir|
      dir.up do
        execute "UPDATE shares SET active = TRUE WHERE active IS NULL"
      end
    end
  end
end
