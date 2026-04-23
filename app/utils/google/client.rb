require 'google/apis/calendar_v3'
module Google
  class Client
    def initialize
      puts 'Google::Client.initialize'
      @oauth_credentials = Current.get_oauth_credentials
    end

    def service
      @service ||= begin
        s = Google::Apis::CalendarV3::CalendarService.new
        s.authorization = authorization
        s
      end
    end

    private
  
    def authorization
      Signet::OAuth2::Client.new(
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        access_token: @oauth_credentials.google_access_token,
        refresh_token: @oauth_credentials.google_refresh_token,
        token_credential_uri: 'https://oauth2.googleapis.com/token'
      )
    end
  end
end