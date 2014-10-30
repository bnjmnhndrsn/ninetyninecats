Rails.application.routes.draw do
  root to: "cats#index"
  resources :cats
  resources :cat_rental_requests do
    post "approve", to: 'cat_rental_requests#approve'
    post "deny", to: 'cat_rental_requests#deny'
  end
  
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy, :index]
  
end
