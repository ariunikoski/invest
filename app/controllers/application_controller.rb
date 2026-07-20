class ApplicationController < ActionController::Base
  # AUTHENTICATION
  before_action :require_authentication, if: -> { Rails.configuration.require_authentication }
  skip_before_action :require_authentication, only: [:set_time_zone]
  helper_method :current_user


  before_action :set_current_holder
  before_action :set_time_zone

  def set_time_zone
    Time.zone = session[:time_zone] if session[:time_zone].present?
  end

  def set_current_holder
    if session[:holder_id].present?
      Current.holder = Holder.find_by(id: session[:holder_id])
    elsif current_user && current_user.restricted_to_holder
      set_current_holder_from_value current_user.restricted_to_holder
    else
      # fallback if not set or invalid
      default_holder = Holder.find_by(default: true)
      if default_holder
        set_current_holder_from_value(default_holder)
      end
    end
  end

  def set_current_holder_from_value value
    Current.holder = value
    session[:holder_id] = value.id
  end

  # AUTHENTICATION
  def require_authentication
    redirect_to login_path, alert: "You must log in" unless current_user
  end

  def current_user
    return @current_user if defined?(@current_user)

    token_value = cookies.signed[:auth_token]
    token = Token.find_by(value: token_value)
    token.update!(last_used_at: Time.current) if token
    @current_user = token&.user
  end

  def ensure_google_connected!
    creds = Current.get_oauth_credentials

    if creds.google_refresh_token.blank?
      redirect_to '/auth/google_oauth2' and return false
    end
    true
  end
end
