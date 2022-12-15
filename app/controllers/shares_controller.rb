class SharesController < ApplicationController
  def index
    @shares = Share.order(:name)
  end
  
  def show
    @share='try from here'
    render partial: 'shares/show'
  end
end