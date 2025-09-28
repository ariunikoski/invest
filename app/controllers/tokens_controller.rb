class TokensController < ApplicationController
  def index
    @tokens = current_user.tokens.order(last_used_at: :desc)
  end

  def destroy
    token = current_user.tokens.find(params[:id])
    token.destroy
    cookies.delete(:auth_token) if token.value == cookies.signed[:auth_token]
    redirect_to tokens_path, notice: "Device/session revoked"
  end
end
