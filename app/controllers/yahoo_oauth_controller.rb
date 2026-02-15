class YahooOauthController < ApplicationController

  CLIENT_ID     = "dj0yJmk9THRNV3FmdHpvMXZoJmQ9WVdrOVR6UndXWGxqTVdvbWNHbzlNQT09JnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PWEy"
  CLIENT_SECRET = "ef8efc49e320cc8eae081d019fd493c3ce55518f"

  def start
    puts '>>> yahoo_oauth.start called'
    byebug
    return redirect_to root_path if Current.get_yahoo_oauth(session).yahoo_oauth_in_progress?

    Current.get_yahoo_oauth(session).start_oauth!

    puts ">>> Session ID before redirect: #{session.id}"
    puts ">>> Stored post_oauth_action: #{session[:post_oauth_action].inspect}"

    redirect_to oauth_authorize_url, allow_other_host: true
  end

  def callback
    byebug
    code = params[:code]
    raise "Missing auth code" if code.blank?

    token = exchange_code_for_token(code)

    Current.get_yahoo_oauth(session).finish_oauth!(
      token["access_token"],
      token["refresh_token"],
      token["expires_in"]
    )

    puts '>>> before call to resume'
    puts ">>> Session ID after redirect: #{session.id}"
    puts ">>> Stored post_oauth_action: #{session[:post_oauth_action].inspect}"
    resume_post_oauth_action
    puts '>>> post call to resume'
  rescue => e
    puts '>>> rescule called with ', e
    Current.get_yahoo_oauth(session).clear_oauth!
    #redirect_to root_path, alert: e.message
  end

  def self.get_client_id
    CLIENT_ID
  end

  def self.get_client_secret
    CLIENT_SECRET
  end

  private


      #scope: "sdct-w",
      #scope: "calendar",
  def oauth_authorize_url
    query = {
      client_id: CLIENT_ID,
      response_type: "code",
      redirect_uri: callback_url,
      state: SecureRandom.hex(16)
    }.to_query

    "https://api.login.yahoo.com/oauth2/request_auth?#{query}"
  end

  def callback_url
    # NOTE THIS HAS TO COMPLETELY MATCH WHAT IS DEFINED IN developer.yahoo.com
    #"#{request.base_url}/yahoo_oauth/callback"
    "https://onomatopoetically-noncataclysmic-glenda.ngrok-free.dev/yahoo_oauth/callback"
  end

  def exchange_code_for_token(code)
    HTTParty.post(
      "https://api.login.yahoo.com/oauth2/get_token",
      basic_auth: { username: CLIENT_ID, password: CLIENT_SECRET },
      body: {
        grant_type: "authorization_code",
        code: code,
        redirect_uri: callback_url
      }
    ).parsed_response
  end

  def resume_post_oauth_action
    puts '>>> called resume'
    byebug
    data = session.delete(:post_oauth_action)
    if data
      redirect_to url_for(
        controller: 'dashboard',
        action: 'create_calendar_event',
        **data,
        only_path: true
      )
    else
      redirect_to root_path
    end
  end
end
