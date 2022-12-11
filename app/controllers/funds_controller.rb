class FundsController < ApplicationController
  def index
    @funds = Fund.order(:name)
  end
end