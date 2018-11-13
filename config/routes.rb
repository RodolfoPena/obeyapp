Rails.application.routes.draw do

  resources :teams, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  get 'pages/index'
  get 'pages/prices'
  get 'pages/evolution'
  get 'pages/certification'
  get 'pages/obeya_global'
  get 'pages/prototipe'

  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }
  root to: 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
