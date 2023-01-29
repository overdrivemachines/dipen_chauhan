class Contact < MailForm::Base
  attribute :name
  attribute :email
  attribute :subject
  attribute :message

  def headers
    { to: "PLEASE-CHANGE-ME@example.org" }
  end
end
