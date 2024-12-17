class SalesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  
  def destroy
    sale = Sale.find(params[:id].to_i)
    return head :not_found if !sale
    sale.destroy
    head :ok
  end
  
  def update
    # Note - this code has never been run, currently cant do updates, it never gets here - should also check validity of params?
    sale = Sale.find(params[:id])
    return head :bad_request if !sale
    updater = JSON.parse(params[:Sale])
    sale_date =  updater["sale_date"]
    updater[:sale_date] = Date.strptime(sale_date,'%d/%m/%y')  if sale_date && !sale_date.empty?
	sale.update(updater)
    head :ok
  end
  
end
  
