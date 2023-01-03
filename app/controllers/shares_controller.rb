class SharesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
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
  
  def update
    puts '>>> update entered!!! Hooray', params
    share = Share.find(params[:id])
    return head :bad_request if !share
    puts '>>> share  = ', share
	share.update(JSON.parse(params[:Share]))
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