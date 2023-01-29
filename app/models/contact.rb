class Contact < MailForm::Base
  attribute :name,    validate: true
  attribute :email,   validate: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i
  attribute :subject, validate: true
  attribute :message, validate: true
  attribute :nickname, captcha: true

  def headers
    {
      to: "get.dipen@gmail.com",
      subject:,
      from: %("#{name}" <#{email}>)
    }
  end
end
