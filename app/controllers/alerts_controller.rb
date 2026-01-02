class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def set_alert_status
    alert_id = params[:id]
    status = params[:status]
    alert = Alert.find(alert_id)
    alert.update(alert_status: status)

    render json: { success: true }
  end
end