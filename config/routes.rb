# == Route Map
#
#           Prefix Verb   URI Pattern                    Controller#Action
#       categories GET    /categories(.:format)          categories#index
#                  POST   /categories(.:format)          categories#create
#     new_category GET    /categories/new(.:format)      categories#new
#    edit_category GET    /categories/:id/edit(.:format) categories#edit
#         category PATCH  /categories/:id(.:format)      categories#update
#                  PUT    /categories/:id(.:format)      categories#update
#                  DELETE /categories/:id(.:format)      categories#destroy
#         projects GET    /projects(.:format)            projects#index
#                  POST   /projects(.:format)            projects#create
#      new_project GET    /projects/new(.:format)        projects#new
#     edit_project GET    /projects/:id/edit(.:format)   projects#edit
#          project PATCH  /projects/:id(.:format)        projects#update
#                  PUT    /projects/:id(.:format)        projects#update
#                  DELETE /projects/:id(.:format)        projects#destroy
#             root GET    /                              home#index
#       home_about GET    /home/about(.:format)          home#about
#   home_portfolio GET    /home/portfolio(.:format)      home#portfolio
#     home_contact GET    /home/contact(.:format)        home#contact
#            login GET    /login(.:format)               sessions#new
#                  POST   /login(.:format)               sessions#create
#           logout DELETE /logout(.:format)              sessions#destroy
#     edit_session GET    /sessions/:id/edit(.:format)   sessions#edit
# sessions_message GET    /sessions/message(.:format)    sessions#message

Rails.application.routes.draw do
  resources :categories, except: :show
  resources :projects, except: [:show]
  root to: 'home#index'
  get 'home/about'
  get 'home/portfolio'
  get 'home/contact'

  # Login / Sessions
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "sessions/:id/edit", to: "sessions#edit", as: "edit_session" # login link
  get "sessions/message"
end
