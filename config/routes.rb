Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: 'api/artworks#index'

  namespace :api do
    resource :users, only: [:create]
    post "/login", to: "auth#login"
    get "/auto_login", to: "auth#auto_login"
    get "/user_is_authed", to: "auth#user_is_authed"
    resources :artworks do
      member do
        get :image
        options :index
      end
    end
    get :cv, controller: :cv, action: :index
    post :new_contact, controller: :contacts, action: :new_contact
    post :sign_in, controller: :users, action: :sign_in
  end
end
