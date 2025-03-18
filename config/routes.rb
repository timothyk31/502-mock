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
          get '/members/auth/failure', to: 'omniauth_callbacks#failure'
     end

     resources :members, controller: 'member', only: %i[index show edit update destroy] do
          collection do
               get 'search', to: 'member#search'
               get 'attendance_chart', to: 'member#attendance_chart'
               get 'attendance_line', to: 'member#attendance_line'
               get 'list', to: 'member#list'
               get 'turbo_stream_query', to: 'member#turbo_stream_query'
          end
     end

     patch 'members/:id', to: 'member#update_roles'

     resources :admin, only: :index do
          collection do
               patch :update_roles
          end
     end
     resources :events do
          collection do
               get 'search', to: 'events#search'
               get 'attendance_chart', to: 'events#attendance_chart'
               get 'popular', to: 'events#popular_events'
          end
     end

     # Added for absent members
     get 'events/:event_id/non_attendees', to: 'attendances#non_attendees', as: :event_non_attendees

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

get 'documentation', to: 'documentation#index'

     resources :transactions

     get 'admin', to: 'admin#index'

     root to: 'member#index'
end
