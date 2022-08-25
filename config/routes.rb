Rails.application.routes.draw do
  get 'users/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
  get "/", to: "pages#index"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  
  resources :articles do
    resources :comments
  end

  get 'profile', action: :profile, controller: 'users'

  resources :users
  
  get "/signup", to: "users#new"
  get "/login", to: "users#login_form"
  post "/login", to: "users#login"
  get "/logout", to: "users#logout"

end
