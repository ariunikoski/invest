require 'google/apis/calendar_v3'
module Google
  class WithFreshToken
    def initialize
    end

    def with_fresh_token
      client = oauth_client
  
      if token_expired?
        return unless refresh!(client) 
      end
  
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
  
      yield service
    end
  
    def oauth_client
      oauth_credentials = Current.get_oauth_credentials
      Signet::OAuth2::Client.new(
        client_id: Rails.application.credentials.dig(:google, :client_id),
        client_secret: Rails.application.credentials.dig(:google, :client_secret),
        token_credential_uri: 'https://oauth2.googleapis.com/token',
        access_token: oauth_credentials.google_access_token,
        refresh_token: oauth_credentials.google_refresh_token
      )
    end
  
    def token_expired?
      oauth_credentials = Current.get_oauth_credentials
      oauth_credentials.google_token_expires_at.nil? || Time.current >= oauth_credentials.google_token_expires_at
    end
  
    def refresh!(client)
      success = true
      begin
        client.refresh!
      rescue => e
        success = false
        puts "Failed to do refresh with ", e
      end
          
      oauth_credentials = Current.get_oauth_credentials
      if success
        oauth_credentials.google_access_token = client.access_token
        oauth_credentials.google_token_expires_at = Time.current + client.expires_in.seconds
      else
        oauth_credentials.google_access_token = nil
        oauth_credentials.google_token_expires_at = nil
        oauth_credentials.google_refresh_token = nil
        oauth_credentials.google_uid = nil
      end
      oauth_credentials.save!
      success
    end
  end
end
