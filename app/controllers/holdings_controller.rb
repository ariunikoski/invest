class HoldingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    new_holding_params = params.permit(:amount, :cost, :account, :purchase_date, :hin)
    purchase_date =  new_holding_params["purchase_date"]
    new_holding_params[:purchase_date] = Date.strptime(purchase_date,'%d/%m/%y')  if purchase_date && !purchase_date.empty?
    holding = Holding.new(new_holding_params)
    klass = Kernel.const_get(params[:klass])
    obj = klass.find(params[:klass_id])
    obj.holdings << holding
    obj.save!

    flash[:preselect_klass] = klass.name
    flash[:preselect_klass_id] = obj.id
    flash[:tab_name] = 'Holdings'
    redirect_to shares_url
  end
  
  def destroy
    holding = Holding.find(params[:id].to_i)
    return head :not_found if !holding

    flash[:preselect_klass] = holding.held_by_type
    flash[:preselect_klass_id] = holding.held_by_id
    flash[:tab_name] = 'Holdings'
    holding.destroy
    head :ok
  end
  
  def update
    holding = Holding.find(params[:id])
    return head :bad_request if !holding
    updater = JSON.parse(params[:Holding])
    purchase_date =  updater["purchase_date"]
    updater[:purchase_date] = Date.strptime(purchase_date,'%d/%m/%y')  if purchase_date && !purchase_date.empty?
	holding.update(updater)
    head :ok
  end
  
  def sell
    if params[:selling_amount].blank? || params[:selling_sale_date].blank? || params[:selling_sale_price].blank?
      Log.error("Could not process sale: missing mandatory fields")
    else
      selling_amount = params[:selling_amount].to_i
      selling_sale_date = Date.strptime(params[:selling_sale_date],'%d/%m/%y')
      sale = Sale.create(share_id: params[:selling_share_id],
        holding_id: params[:selling_holding_id],
        sale_date: selling_sale_date,
        amount: selling_amount,
        sale_price: params[:selling_sale_price],
        tax_nis: params[:selling_tax_nis],
        tax_fc: params[:selling_tax_fc],
        service_fee_nis: params[:selling_service_fees_nis],
        service_fee_fc: params[:selling_service_fees_fc])
      holding = sale.holding
      holding.update(amount: holding.amount - selling_amount, amount_sold: (holding.amount_sold || 0) + selling_amount)
    end

    flash[:preselect_klass] = 'Share'
    flash[:preselect_klass_id] = params[:selling_share_id]
    flash[:tab_name] = 'Holdings'
    redirect_to shares_url
  end
end
  