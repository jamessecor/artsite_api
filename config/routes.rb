Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: 'api/artworks#index'

  namespace :api do
    resources :artworks do
      member do
        get :image
      end
    end
    get :cv, controller: :cv, action: :index
    post :new_contact, controller: :contacts, action: :new_contact
  end
end
