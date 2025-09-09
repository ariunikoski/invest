class DashboardController < ApplicationController
  def index
    # Your logic here if needed
    
    # Render the index view
    render 'index'
  end
  
  def load_email_body
    mm = Yahoo::Email.new(Yahoo::Email.email_actions[:get_message_body], params[:id])
    render plain: mm.get_mail_body, status: :ok
  end
end
