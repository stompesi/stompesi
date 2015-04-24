Rails.application.routes.draw do
  root 'home#index'

  resources :vocabularies
  resources :words
end
