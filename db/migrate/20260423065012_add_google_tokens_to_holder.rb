class AddGoogleTokensToHolder < ActiveRecord::Migration[7.0]
  def change
    add_column :holders, :google_access_token, :text
    add_column :holders, :google_refresh_token, :text
    add_column :holders, :google_token_expires_at, :datetime
    add_column :holders, :google_uid, :string
  end
end
