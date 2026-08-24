class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)
    @contact.request = request
    begin
      @contact.deliver
    rescue StandardError
      nil
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message, :nickname).to_h.transform_values do |value|
      value.respond_to?(:strip) ? value.strip : value
    end
  end
end
