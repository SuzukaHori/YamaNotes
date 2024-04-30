# frozen_string_literal: true

Rails.application.routes.draw do
  resource :walk, except: [:index]
  resources :arrivals, except: [:new]
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users do
    resources :arrivals, only: [:index], :to => 'users/arrivals#index'
  end
  devise_scope :user do
    post 'logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
