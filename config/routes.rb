Rails.application.routes.draw do
  resources :domains
  resources :fedi_accounts
  devise_for :users
  root 'application#home'
  get 'home', to: 'application#home'
end
