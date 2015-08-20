Rails.application.routes.draw do
  root 'home#index'

  resources :vocabularies
  resources :folders

  resources :words do
    collection do
      put :mutipule_update
      patch :mutipule_update
    end

    collection do
      get :memorize
    end
    
    collection do
      get :memorize_all
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy'

end
