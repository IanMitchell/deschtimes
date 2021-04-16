# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root to: 'home#index'

  direct :cdn_proxy do |model, options|
    if model.respond_to?(:signed_id)
      route_for(
        :rails_service_blob_proxy,
        model.signed_id,
        model.filename,
        options.merge(host: ENV['ACTIVE_STORAGE_CDN'])
      )
    else
      signed_blob_id = model.blob.signed_id
      variation_key  = model.variation.key
      filename       = model.blob.filename

      route_for(
        :rails_blob_representation_proxy,
        signed_blob_id,
        variation_key,
        filename,
        options.merge(host: ENV['ACTIVE_STORAGE_CDN'])
      )
    end
  end if ENV['ACTIVE_STORAGE_CDN'].present?

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
