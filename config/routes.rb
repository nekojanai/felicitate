Rails.application.routes.draw do
  resources :fedi_accounts do
    get 'authorization'
    post 'authorize'
  end
  devise_for :users
  root 'application#home'
  get 'home', to: 'application#home'
end
