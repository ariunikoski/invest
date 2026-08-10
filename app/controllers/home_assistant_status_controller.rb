class HomeAssistantStatusController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_home_assistant, only: [:create]

  def authenticate_home_assistant
    expected = Rails.application.credentials.home_assistant_api_key

    unless request.headers["X-API-Key"] == expected
      head :unauthorized
    end
  end

  def create
    data = params.permit(
      :status,
      :status_message,
      :smart_home_status,
      :connected_message,
      :disconnected_message
    )

    HomeAssistantStatus.create!(
      status: data[:status],
      status_message: data[:status_message],
      smart_home_status: data[:smart_home_status],
      connected_message: data[:connected_message],
      disconnected_message: data[:disconnected_message]
    )

    # Remove records older than 2 days
    HomeAssistantStatus.where("created_at < ?", 2.days.ago).delete_all

    render json: {}, status: :created
  end

  def get_last_record
    record = HomeAssistantStatus.order(created_at: :desc).first

    if record
      render json: {
        status: record.status,
        status_message: record.status_message,
        smart_home_status: record.smart_home_status,
        connected_message: record.connected_message,
        disconnected_message: record.disconnected_message,
        timestamp: record.created_at
      }
    else
      render json: {}, status: :not_found
    end
  end

  def index
    @records = HomeAssistantStatus.order(created_at: :desc)
  end

end