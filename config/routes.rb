Rails.application.routes.draw do
  root 'home#index'

  resources :vocabularies

  resources :words do
    collection do
      put :mutipule_update
      patch :mutipule_update
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy'

end
