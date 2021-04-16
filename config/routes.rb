# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :groups, only: [:index, :show], param: :token do
        resources :shows, only: [:show], param: :name do
          patch 'episodes', to: 'episodes#update'
          patch 'staff', to: 'staff#update'
        end
      end
    end
  end

  devise_for :users, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register'
  }

  resources :groups do
    resources :shows do
      resources :episodes do
        resources :staff, only: [:new, :create, :edit, :update, :destroy]
      end

      resources :terms, only: [:new, :create, :destroy]
      resources :projects, only: [:new, :create, :update, :destroy]
    end

    resources :tokens, only: [:update]
    resources :members, except: [:show]
    resources :users, except: [:edit, :update]
    resources :webhooks, except: [:show]
    resources :positions, except: [:show]
    resources :projects, only: [:index]
  end

  get 'donations', to: 'donations#index'
  get 'documentation', to: 'documentation#index'
  get 'documentation/discord', to: 'documentation#discord'
  get 'documentation/api', to: 'documentation#api'
  get 'documentation/webhooks', to: 'documentation#webhooks'
end
