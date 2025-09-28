class ApplicationController < ActionController::Base
  # AUTHENTICATION
  before_action :require_authentication, if: -> { Rails.configuration.require_authentication }
  skip_before_action :require_authentication, only: [:set_time_zone]


  before_action :set_current_holder
  before_action :set_time_zone

  def set_time_zone
    Time.zone = session[:time_zone] if session[:time_zone].present?
  end

  def set_current_holder
    if session[:holder_id].present?
      Current.holder = Holder.find_by(id: session[:holder_id])
    else
      # fallback if not set or invalid
      default_holder = Holder.find_by(default: true)
      if default_holder
        Current.holder = default_holder
        session[:holder_id] = default_holder.id
      end
    end
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
end
