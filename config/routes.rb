# frozen_string_literal: true

Rails.application.routes.draw do
  resource :walk, except: [:index]
  resources :arrivals, except: [:new]
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root to: 'statics#top'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
