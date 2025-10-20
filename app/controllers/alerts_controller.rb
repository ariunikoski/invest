class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def set_alert_status
    puts '>>> set_alert_status called with', params
    # >>> data = JSON.parse(request.body.read)   # <-- parse the JSON yourself
    # >>> alert_id = data["id"]
    # >>> status = data["status"]
    alert_id = params[:id]
    status = params[:status]
    puts(">>> got data with id and status", alert_id, status)
    alert = Alert.find(alert_id)
    alert.update(alert_status: status)

    render json: { success: true }
  end
end