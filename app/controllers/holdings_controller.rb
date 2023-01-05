class HoldingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    new_holding_params = params.permit(:amount, :cost, :account)
    holding = Holding.new(new_holding_params)
    klass = Kernel.const_get(params[:klass])
    obj = klass.find(params[:klass_id])
    obj.holdings << holding
    obj.save!
    redirect_to shares_url
  end
  
  def destroy
    puts '>>> delete called wioth', params
    holding = Holding.find(params[:id].to_i)
    return head :not_found if !holding
    holding.destroy
    head :ok
  end
  
  def update
    puts '>>> holdings update entered!!! Hooray', params
    holding = Holding.find(params[:id])
    return head :bad_request if !holding
    puts '>>> holding  = ', holding
	holding.update(JSON.parse(params[:Holding]))
    head :ok
  end
end
  