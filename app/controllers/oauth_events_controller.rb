class OauthEventsController < ApplicationController
  def create
    result = YahooCalendarService.create_event(session, event_payload)

    if result[:ok]
      redirect_to root_path, notice: "Event created"
    elsif result[:error] == :auth_required
      session[:post_oauth_action] = event_payload
      redirect_to yahoo_oauth_start_path
    else
      redirect_to root_path, alert: result[:message]
    end
  end

  private

  def event_payload
    {
      title: params[:title],
      start: params[:start],
      end: params[:end]
    }
  end
end
