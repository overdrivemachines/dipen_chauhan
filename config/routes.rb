# == Route Map
#
#         Prefix Verb URI Pattern               Controller#Action
#           root GET  /                         home#index
#     home_about GET  /home/about(.:format)     home#about
# home_portfolio GET  /home/portfolio(.:format) home#portfolio
#   home_contact GET  /home/contact(.:format)   home#contact

Rails.application.routes.draw do
  resources :projects
  root to: 'home#index'
  get 'home/about'
  get 'home/portfolio'
  get 'home/contact'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
