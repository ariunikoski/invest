# app/controllers/timezones_controller.rb
class TimezonesController < ApplicationController

  def set
    session[:time_zone] = params[:time_zone]
    head :ok
  end
end
