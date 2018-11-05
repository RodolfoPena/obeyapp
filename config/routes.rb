Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  get 'pages/prices'
  get 'pages/evolution'
  get 'pages/certification'
  get 'pages/obeya_global'
  get 'pages/prototipe'
  root to: 'pages#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
