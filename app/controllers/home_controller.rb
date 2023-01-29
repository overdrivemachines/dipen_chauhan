class HomeController < ApplicationController
  def index
    @contact = Contact.new
    @categories = Category.all
    @projects = Project.all
  end
end
