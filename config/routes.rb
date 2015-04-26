Rails.application.routes.draw do
  root 'home#index'

  resources :vocabularies

  resources :words do
    collection do
      put :mutipule_update
      patch :mutipule_update
    end
  end

end
