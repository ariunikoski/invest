class SharesController < ApplicationController
  def index
    @shares = Share.order(:name)
  end
end