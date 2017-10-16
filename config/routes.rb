# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  root 'dashboard#index'

  namespace :api do
    resources :users, except: %i(delete edit) do
      get :me, on: :collection
    end
    resources :invitations, only: %i(create index show destroy)

    resources :transfers, only: %i(index create) do
      member do
        put :accept
        put :reject
      end
    end

    resources :balances, only: [:index]

    resources :orders, except: %i(new edit) do
      resources :dishes, except: %i(new edit) do
        post :copy, on: :member
      end
      member do
        put :change_status
      end
      collection do
        get :latest
      end
    end
  end

  ### Single Page App ###
  %w(
    orders
    orders/today
    orders/today/:order_id
    orders/new
    orders/:order_id/edit
    orders/:order_id/dishes/:dish_id/edit
    orders/:order_id/dishes/new
    account_numbers
    settings
    transfers
    transfers/new
    members
    you
  ).each do |route|
    get route, to: 'dashboard#index'
  end

  # separate to have named routes
  get 'orders/:order_id', to: 'dashboard#index', as: 'order'
  get 'invitations/:id', to: 'dashboard#index', as: 'invitation'
end
