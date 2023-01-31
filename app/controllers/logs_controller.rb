class LogsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def clear_logs
    Log.where(displayed: 0).update_all(displayed: 1)
    head :ok
  end
end
