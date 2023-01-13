class SharesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @rates = {}
    ExchangeRate.all.each do |rate|
      @rates[rate.currency_code] = rate.exchange_rate
    end
    @shares = Share.order(:name)
  end
  
  def show
    @share=Share.find(params[:id])
    render partial: 'shares/show'
  end
  
  def create
    new_share_params = params.permit(:name, :currency, :israeli_number, :symbol)
    Share.new(new_share_params).save!
    redirect_to shares_url
  end
  
  def destroy
    puts '>>> delete called wioth', params
    share = Share.find(params[:id].to_i)
    return head :not_found if !share
    share.destroy
    head :ok
  end
  
  def update
    share = Share.find(params[:id])
    return head :bad_request if !share
    j_params = JSON.parse(params[:Share])
    j_params.keys.each { |key| j_params[key] = j_params[key].strip }
    puts '>>> paramsjson  = ', j_params
	share.update(j_params)
    head :ok
  end
  
  def load_yahoo_historicals
    puts '>>> started load_yahoo_historicals'
    @share=Share.find(params[:id])
    puts '>>> share = ', @share
    loader = Yahoo::HistoricalData.new(@share)
    loader.load
    render partial: 'shares/show'
  end
  
  def yahoo_current_prices
    puts '>>> entered load yahoo current prices'
    loader = Yahoo::Quotes.new
    loader.load
    head :ok
  end
end