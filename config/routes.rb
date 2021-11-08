Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'artworks#index'

  # TODO: move to api namespace
  resources :artworks
  get :cv, controller: :cv, action: :index

  namespace :api do
    post :new_contact, controller: :contacts, action: :new_contact
  end
end
