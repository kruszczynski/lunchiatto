Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'pages#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Upmin::Engine => '/admin'
  end

  resources :transfers, only: [:new, :create]
  resources :users, except: [:delete] do
    get :my_balances, on: :member
    collection do
      get :dashboard
      get :account_numbers
    end
  end

  resources :transfers, only: [] do
    member do
      put :accept
      put :reject
    end
  end

  resources :orders, except: [:destroy] do
    resources :dishes, except: [:show] do
      get :copy, on: :member
    end
    member do
      put :change_status
      get :shipping
      put :finalize
    end
    collection do
      get :latest
    end
  end
end
