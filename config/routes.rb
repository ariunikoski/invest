Rails.application.routes.draw do
  # Define your applicatload_yahoo_current_pricesload_yahoo_current_prices/shares/load_yahoo_current_prices/shares/load_yahoo_current_pricesion routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "shares#index"
  resources :shares
 
  # config/routes.rb
  post "/set_timezone", to: "timezones#set"

  get '/shares/load_yahoo_historicals/:id', to: 'shares#load_yahoo_historicals'
  get '/shares/load_yahoo_summary/:id', to: 'shares#load_yahoo_summary'
  get 'yahoo_current_prices', to: 'shares#yahoo_current_prices'
  get 'shares_by_account', to: 'shares#shares_by_account'
  get 'breakdown_by_sector', to: 'shares#breakdown_by_sector'
  get 'breakdown_by_sector_condensed', to: 'shares#breakdown_by_sector_condensed'
  get 'projected_income', to: 'shares#projected_income'
  get 'load_all_dividends', to: 'shares#load_all_dividends'
  get 'export_projected_income', to: 'shares#export_projected_income'
  put 'clear_logs', to: 'logs#clear_logs'
  post 'holdings/sell', to: 'holdings#sell'
  post "shares/change_holder", to: "shares#change_holder", as: :shares_change_holder

  resources :funds
  resources :sales
  resources :holdings
  resources :exchange_rates
  get 'load_rates', to: 'exchange_rates#load_rates'
  
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/load_email_body', to: 'dashboard#load_email_body'

  resources :tokens, only: [:index, :destroy]

  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

end
