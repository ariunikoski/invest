module Yahoo
  class Oauth
    def initialize(session)
      @session = session
      inval = @session.delete(:yahoo_oauth)
      puts '>>> Oauth initialized with', inval
      inval == nil ? clear_oauth! : load_from_inval(inval)
    end

    def yahoo_token_present?
      @access_token.present? && @refresh_token.present?
    end

    def yahoo_token_expired?
      @token_expires_at.blank? || Time.current >= @token_expires_at
    end

    def yahoo_oauth_in_progress?
      @oauth_in_progress
    end

    def yahoo_access_token
      @access_token
    end

    def yahoo_refresh_token
      @refresh_token
    end

    def start_oauth!
      @oauth_in_progress = true
      save_to_session
    end

    def finish_oauth!(access, refresh, expires_in)
      @access_token = access
      @refresh_token = refresh
      @token_expires_at = Time.current + expires_in.seconds
      @oauth_in_progress = false
      save_to_session
    end
  
    def clear_oauth!
      puts '>>> clear_oauth called'
      @access_token = nil
      @refresh_token = nil
      @token_expires_at = nil
      @oauth_in_progress = false
      save_to_session
    end   

    def to_h
      {
        access_token: @access_token,
        refresh_token: @refresh_token,
        token_expires_at: @token_expires_at == nil ? nil : @token_expires_at.iso8601,
        oauth_in_progress: @oauth_in_progress.to_s
      }
    end

    def load_from_inval(inval)
        puts '>>> load_from_inval called'
        @access_token = inval["access_token"]
        @refresh_token = inval["refresh_token"]
        @token_expires_at = inval["token_expires_at"]
        @token_expires_at = Time.iso8601(@token_expires_at) if @token_expires_at
        @oauth_in_progress = inval["oauth_in_progress"] == 'true'
        puts '>>> load_from inval produced:', @access_token, @refresh_token, @token_expires_at, @oauth_in_progress
    end

    def save_to_session
      puts '>>> save to session called with:', to_h
      @session[:yahoo_oauth] = to_h
    end
  end
end