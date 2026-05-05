class OmniauthController < ApplicationController
  def create
    puts 'OmniauthController.create'
    auth = request.env['omniauth.auth']

    oauth_credentials = Current.get_oauth_credentials

    credentials = auth.credentials

    oauth_credentials.google_uid = auth.uid
    oauth_credentials.google_access_token = credentials.token
    oauth_credentials.google_refresh_token = credentials.refresh_token.presence || oauth_credentials.google_refresh_token
    oauth_credentials.google_token_expires_at = Time.at(credentials.expires_at)
    oauth_credentials.save!

    redirect_to root_path, notice: "Google Calendar connected"
  end
end