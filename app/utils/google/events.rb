require 'google/apis/calendar_v3'
require 'signet/oauth_2/client'
module Google
  class Events

    SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'
  
    def initialize
      Log.info(">>> events initialized")
      @oauth_credentials = Current.get_oauth_credentials
    end
  
    def events_between(start_date, end_date)
      time_min = start_date.beginning_of_day.iso8601
      time_max = end_date.end_of_day.iso8601
      puts ">>> time_min: #{time_min}"
      puts ">>> time_max: #{time_max}"
      with_fresh_token do |service|
        Log.info(">>> inside with_fresh_token body")
        results = nil
        begin
          results = service.list_events(
            'primary',
            time_min: time_min,
            time_max: time_max,
            single_events: true,
            order_by: 'startTime'
          )
        rescue => e
          puts 'Google Client Failure with: ', e. status_code, e.body
        end
        results
      end
    end
  
    private
  
    def with_fresh_token
      Log.info(">>> with_fresh_token started")
      client = oauth_client
  
      if token_expired?
        Log.info(">>> token apparently expired - about to call refresh")
        refresh!(client)
      end
  
      Log.info(">>> calling calendar service")
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
  
      yield service
    end
  
    def oauth_client
      Log.info(">>> oauth_client called")
      Signet::OAuth2::Client.new(
        client_id: Rails.application.credentials.dig(:google, :client_id),
        client_secret: Rails.application.credentials.dig(:google, :client_secret),
        token_credential_uri: 'https://oauth2.googleapis.com/token',
        access_token: @oauth_credentials.google_access_token,
        refresh_token: @oauth_credentials.google_refresh_token
      )
    end
  
    def token_expired?
      Log.info(">>> checking if token expired - expires at: #{@oauth_credentials.google_token_expires_at} and not is #{Time.current}")
      @oauth_credentials.google_token_expires_at.nil? || Time.current >= @oauth_credentials.google_token_expires_at
    end
  
    def refresh!(client)
      Log.info(">>> refresh! called")
      client.refresh!
  
      Log.info(">>> updating oauth_credentials - expires in #{client.expires_in.seconds} seconds")
      @oauth_credentials.google_access_token = client.access_token,
      @oauth_credentials.google_token_expires_at = Time.current + client.expires_in.seconds
      @oauth_credentials.save!
      Log.info(">>> after update expires at is: #{Current.get_oauth_credentials.google_token_expires_at}")
    end
  end
end