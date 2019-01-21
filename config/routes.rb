Rails.application.routes.draw do

  get 'problems/index'
  get 'tasks/index'
  get 'charts/commitment_level'

  resources :teams do
    resources :targets, only: [:create, :edit, :update], controller: 'targets', action: 'nested_create' do
      resources :problems, only: [:create]
      resources :commitments, only: [:create], controller: 'commitments', action: 'nested_create'
    end
  end

  resources :targets

  resources :commitments do
    resources :tasks, only: [:new, :create, :destroy, :update]
    member do
      patch :complete
    end
  end

  resources :problems

  resources :tasks, only: [] do
    member do
      patch :done
    end
  end

  namespace :charts do
    get 'commitment-level'
    get 'commitment-status'
    get 'planning-level'
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
