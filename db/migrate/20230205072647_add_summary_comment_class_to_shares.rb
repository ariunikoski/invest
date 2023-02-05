class AddSummaryCommentClassToShares < ActiveRecord::Migration[7.0]
  def change
    add_column :shares, :comments, :text
    add_column :shares, :yahoo_summary, :text
    add_column :shares, :sector, :string
    add_column :shares, :industry, :string
  end
end
