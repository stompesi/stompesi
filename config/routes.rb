Rails.application.routes.draw do
  root 'home#index'

  resources :vocabularies
  resources :folders

  resources :words do
    collection do
      put :mutipule_update
      patch :mutipule_update
      get :get_word_from_other_information, to: 'words#get_word_from_other_information'
      post :set_word_to_other_server, to: 'words#set_word_from_other_server'
      get :input_word
      get :memorize_all
      get :memorize
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy'

end
