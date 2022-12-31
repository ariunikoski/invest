Rails.application.routes.draw do
  # Define your applicatload_yahoo_current_pricesload_yahoo_current_prices/shares/load_yahoo_current_prices/shares/load_yahoo_current_pricesion routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "shares#index"
  resources :shares
  
  get '/shares/load_yahoo_historicals/:id', to: 'shares#load_yahoo_historicals'
  get 'yahoo_current_prices', to: 'shares#yahoo_current_prices'

  resources :funds
end
