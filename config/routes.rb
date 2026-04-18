# frozen_string_literal: true

Rails.application.routes.draw do
  resources :walks do
    resource :deactivation, only: [:create], controller: 'walks/deactivations'
    scope module: 'walk' do
      resources :arrivals, only: [:index]
    end
  end

  namespace :public do
    resources :walks, only: [] do
      scope module: 'walks' do
        resources :arrivals, only: [:index]
      end
    end
  end

  resources :arrivals, except: [:new] do
    scope module: 'arrivals' do
      resource :report, only: %i(show)
      resource :image, only: %i(create)
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, only: [:destroy]
  devise_scope :user do
    post 'logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # 以下はURLの修正に伴いリダイレクトさせているが、後に削除する
  scope module: 'tmp' do
    resources :users, only: [] do
      resources :arrivals, only: :index
    end
    get '/walk', to: 'walks#show'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
