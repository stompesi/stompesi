Rails.application.routes.draw do
  root 'home#index'

  resources :vocabularies
  resources :folders

  resources :words do
    collection do
      put :mutipule_update
      patch :mutipule_update
      get :get_word_info, to: 'words#get_word_information'
      get :input_word
      get :memorize
      get :memorize_all
      post :overlap, to: 'words#update_overlap'
    end
  end

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy'

end