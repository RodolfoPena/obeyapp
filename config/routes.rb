Rails.application.routes.draw do

  get 'charts/commitment_level'

  resources :teams do
    resources :targets, only: [:create, :edit, :update], controller: 'targets', action: 'nested_create' do
      resources :commitments, only: [:create], controller: 'commitments', action: 'nested_create'
    end
  end

  resources :targets
  resources :commitments do
    member do
      patch :complete
    end
  end

  namespace :charts do
    get 'commitment-level'
  end

  get 'pages/index'
  get 'pages/prices'
  get 'pages/evolution'
  get 'pages/competition'
  get 'pages/obeya_global'
  get 'pages/prototipe'
  get 'pages/obeya_skills'

  devise_for :users, controllers: {
        registrations: 'users/registrations'
      }
  root to: 'pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
