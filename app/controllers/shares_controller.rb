class SharesController < ApplicationController
  def index
    @shares = Share.order(:name)
  end
  
  def show
    @share=Share.find(params[:id])
    render partial: 'shares/show'
  end
  
  def load_yahoo_historicals
    puts '>>> started load_yahoo_historicals'
    @share=Share.find(params[:id])
    puts '>>> share = ', @share
    loader = Yahoo::HistoricalData.new(@share)
    loader.load
    render partial: 'shares/show'
  end
end