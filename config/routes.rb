# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :users do
    get 'arrivals/index'
  end
  resource :walk, except: [:index]
  resources :arrivals, except: [:new]
  get '/stations', to: 'stations#index', defaults: { format: 'json' }
  get '/users/:id/arrivals', to: 'users/arrivals#index', :as => :public_arrivals
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root to: 'statics#top'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
