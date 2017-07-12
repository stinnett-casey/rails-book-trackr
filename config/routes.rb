Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  post '/user_exists' => 'users#user_exists'
  resources :users
  resources :user_books
  resources :books
  root 'home#index'
end
