# app/controllers/timezones_controller.rb
class TimezonesController < ApplicationController
  # >>> might need later? skip_before_action :verify_authenticity_token, only: [:set] # or handle via CSRF token in fetch

  def set
    session[:time_zone] = params[:time_zone]
    head :ok
  end
end
