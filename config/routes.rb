# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :members, controllers: { omniauth_callbacks: 'omniauth_callbacks', sessions: 'sessions' }
  # devise_scope :member do
  #   get 'member/sign_in', to: 'member/sessions#new', as: :new_member_session
  #   get 'member/sign_out', to: 'member/sessions#destroy', as: :destroy_member_session
  # end
  devise_scope :member do
    get 'member/sign_in', to: 'sessions#new', as: :new_member_session
    get 'member/sign_out', to: 'sessions#destroy', as: :destroy_member_session
  end

  resources :members, only: %i[index show edit update destroy]
  resources :admins, only: :index
  resources :events
  resources :attendances do
    collection do
      post :verify
    end
  end
  resources :speakers

  resources :developer, only: %i[index] do
    collection do
      patch :update_roles
    end
  end

  get 'admin', to: 'admin#index'

  root to: 'member#index'
end
