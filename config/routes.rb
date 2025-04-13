# frozen_string_literal: true

Rails.application.routes.draw do
  resources :walks do
    resources :arrivals, only: [:index], :to => 'walks/arrivals#index'
  end
  resources :arrivals, except: [:new] do
    resource :report, only: %i(show), controller: "arrivals/report"
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, only: [:destroy]
  devise_scope :user do
    post 'logout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # 以下の2つのルーティングはURLの修正に伴いリダイレクトさせているが、後に削除する
  scope module: 'temp' do
    resources :users, only: [] do
      resources :arrivals, only: :index
    end
    get '/walk', to: 'walks#show'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
