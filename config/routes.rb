Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get "orders/create"
  get "orders/index"
  get "orders/show"
  root 'pages#home'
  devise_for :users
  resources :products
  
  resource :cart, only: [:show] do
    resources :cart_items, only: [:create, :update, :destroy]
  end

  resources :orders, only: [:create, :index, :show]

end
