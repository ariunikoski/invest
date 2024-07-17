class ExchangeRatesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @rates = ExchangeRate.order(:currency_code)
  end
  
  def load_rates
    loader = CurrencyConverter::LoadAllCurrencies.new
    loader.load
    Rates::RatesCache.instance.clear_rates
    head :ok
  end
end
  