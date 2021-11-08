Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'artworks#index'

  resources :artworks
  # resources :shows
  get :cv, controller: :cv, action: :index
end
