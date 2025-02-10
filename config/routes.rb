Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :members, controllers: { omniauth_callbacks: 'member/omniauth_callbacks' }
  devise_scope :member do
    get 'member/sign_in', to: 'member/sessions#new', as: :new_member_session
    get 'member/sign_out', to: 'member/sessions#destroy', as: :destroy_member_session
  end

  resources :member, only: %i[index show]
  resources :admin, only: :index

  get 'admin', to: 'admin#index'

  root to: 'member#index'
end
