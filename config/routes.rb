Rails.application.routes.draw do
  root "stops#index"

  resources :stops, only: [:index, :show]
  resources :routes, only: [:index, :show]
  resources :streets, only: [:index, :show]
  get "about", to: "pages#about"
end