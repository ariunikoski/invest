class ApplicationController < ActionController::Base
  before_action :set_current_holder

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
end
