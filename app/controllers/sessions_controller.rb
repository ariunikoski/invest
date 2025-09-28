class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]


  def new
    # will auto render views/sessions/new.html.haml
  end
  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      friendly_name = DeviceNameService.friendly_name(request.user_agent)
      token = user.tokens.create!(
        device_name: friendly_name,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        last_used_at: Time.current
      )
      cookies.permanent.signed[:auth_token] = token.value
      redirect_to root_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new
    end
  end

  def destroy
    token = Token.find_by(value: cookies.signed[:auth_token])
    token&.destroy
    cookies.delete(:auth_token)
    redirect_to login_path, notice: "Logged out"
  end

end