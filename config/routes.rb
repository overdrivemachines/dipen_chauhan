# == Route Map
#
#         Prefix Verb   URI Pattern               Controller#Action
#       projects GET    /projects(.:format)       projects#index
#                POST   /projects(.:format)       projects#create
#        project GET    /projects/:id(.:format)   projects#show
#                PATCH  /projects/:id(.:format)   projects#update
#                PUT    /projects/:id(.:format)   projects#update
#                DELETE /projects/:id(.:format)   projects#destroy
#           root GET    /                         home#index
#     home_about GET    /home/about(.:format)     home#about
# home_portfolio GET    /home/portfolio(.:format) home#portfolio
#   home_contact GET    /home/contact(.:format)   home#contact

Rails.application.routes.draw do
  resources :projects
  root to: 'home#index'
  get 'home/about'
  get 'home/portfolio'
  get 'home/contact'
end
