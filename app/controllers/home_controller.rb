class HomeController < ApplicationController
  def index
    @contact = Contact.new
    @projects = Project.includes(:category).limit(1)
    @categories = Category.all

    @is_user_signed_in = user_signed_in?
    @current_user = current_user
  end
end
