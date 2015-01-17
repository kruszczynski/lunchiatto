Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'pages#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Upmin::Engine => '/admin'
  end

  resources :users, except: [:delete, :edit]

  resources :transfers, only: [:create] do
    member do
      put :accept
      put :reject
    end
  end

  resources :submitted_transfers, only: [:index]
  resources :received_transfers, only: [:index]
  resources :user_balances, only: [:index]
  resources :user_debts, only: [:index]

  resources :orders, except: [:new, :edit, :destroy] do
    resources :dishes, except: [:new, :edit] do
      post :copy, on: :member
    end
    member do
      put :change_status
    end
    collection do
      get :latest
    end
  end

  ### Single Page App ###
  namespace :app do
    get 'dashboard', to: 'dashboard#index'
    get 'finances', to: 'dashboard#index'
    get 'orders', to: 'dashboard#index'
    get 'orders/new', to: 'dashboard#index'
    get 'orders/:order_id', to: 'dashboard#index'
    get 'orders/:order_id/edit', to: 'dashboard#index'
    get 'orders/:order_id/shipping', to: 'dashboard#index'
    get 'orders/:order_id/dishes/:dish_id/edit', to: 'dashboard#index'
    get 'orders/:order_id/dishes/new', to: 'dashboard#index'
    get 'account_numbers', to: 'dashboard#index'
    get 'settings', to: 'dashboard#index'
    get 'transfers/new', to: 'dashboard#index'
  end

end
