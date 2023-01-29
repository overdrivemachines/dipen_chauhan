class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    @contact.request = request
    @contact.deliver
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message, :nickname)
  end
end
