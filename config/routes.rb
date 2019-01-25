Rails.application.routes.draw do

  namespace :pages do
    get 'obeya_skills'
    get 'index'
    get 'prices'
    get 'evolution'
    get 'competition'
    get 'obeya_global'
    get 'prototipe'

  end

  resources :teams do
    resources :targets, only: [:index, :create, :edit, :update, :destroy], controller: 'teams/targets' do
      resources :problems, only: [:create], controller: 'teams/targets/problems'
      resources :commitments, only: [:create], controller: 'teams/targets/commitments'
    end
  end

  resources :targets
  resources :problems

  resources :commitments do
    resources :tasks, only: [:new, :create, :destroy, :update], controller: 'commitments/tasks'
    member do
      patch :complete
    end
  end

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

  devise_for :users, controllers: {
        registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'
      }

  
  root to: 'pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
