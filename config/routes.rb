Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "shares#index"
  resources :shares
  
  get '/shares/load_yahoo_historicals/:id', to: 'shares#load_yahoo_historicals'

  resources :funds
end
