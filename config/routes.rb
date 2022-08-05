Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/about'
  get 'home/portfolio'
  get 'home/contact'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
