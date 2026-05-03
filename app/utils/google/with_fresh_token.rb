require 'google/apis/calendar_v3'
module Google
  class WithFreshToken
    def initialize
      Log.info(">>> with fresh token initialized")
    end

    def with_fresh_token
      Log.info(">>> with_fresh_token started")
      client = oauth_client
  
      if token_expired?
        Log.info(">>> token apparently expired - about to call refresh")
        return unless refresh!(client) 
      end
  
      Log.info(">>> calling calendar service")
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
  
      yield service
    end
  
    def oauth_client
      oauth_credentials = Current.get_oauth_credentials
      Log.info(">>> oauth_client called client_id: #{Rails.application.credentials.dig(:google, :client_id)}, client_secret: #{Rails.application.credentials.dig(:google, :client_secret)}")
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
      Log.info(">>> checking if token expired - expires at: #{oauth_credentials.google_token_expires_at} and now is #{Time.current}")
      oauth_credentials.google_token_expires_at.nil? || Time.current >= oauth_credentials.google_token_expires_at
    end
  
    def refresh!(client)
      Log.info(">>> refresh! called")
      success = true
      begin
        client.refresh!
      rescue => e
        success = false
        puts "Failed to do refresh with ", e
      end
          
      oauth_credentials = Current.get_oauth_credentials
      if success
        Log.info(">>> updating oauth_credentials - expires in #{client.expires_in.seconds} seconds")
        oauth_credentials.google_access_token = client.access_token
        oauth_credentials.google_token_expires_at = Time.current + client.expires_in.seconds
      else
        Log.info(">>> Failed to refresh")
        oauth_credentials.google_access_token = nil
        oauth_credentials.google_token_expires_at = nil
        oauth_credentials.google_refresh_token = nil
        oauth_credentials.google_uid = nil
      end
      oauth_credentials.save!
      oauth_credentials = Current.get_oauth_credentials # >>>
      Log.info(">>> after update expires at is: #{Current.get_oauth_credentials.google_token_expires_at}")
      success
    end
  end
end
