Rails.application.routes.draw do
  devise_for :users, :controllers => {:sessions => "sessions"}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: 'api/artworks#index'

  namespace :api do

    resource :users, only: [:create] do
      get :auto_login

      member do
        get :jwt_token, controller: :users, action: :jwt_token
      end
    end
    resources :artworks do
      member do
        get :image
        options :index
      end
    end
    get :cv, controller: :cv, action: :index
    post :new_contact, controller: :contacts, action: :new_contact
  end
end
