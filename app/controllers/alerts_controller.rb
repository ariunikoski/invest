class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def set_alert_status
    alert_id = params[:id]
    status = params[:status]
    ignore_until = params[:ignore_until]
    ignore_until = Date.strptime(ignore_until, "%d/%m/%y") if ignore_until.present?
    alert = Alert.find(alert_id)
    alert.update(alert_status: status, ignore_until: ignore_until)

    render json: { success: true }
  end
end