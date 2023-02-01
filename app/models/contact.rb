class Contact < MailForm::Base
  attribute :name,    validate: true
  attribute :email,   validate: /\A([\w.%+-]+)@([\w-]+\.)+(\w{2,})\z/i
  attribute :subject, validate: true
  attribute :message, validate: true
  attribute :nickname, captcha: true

  # c = Contact.new(nickname: 'not_blank', email: 'your@email.com', name: 'José', subject: "Hello", message:"World")
  # c.spam?    #=> true  (raises an error in development, to remember you to hide it)
  # c.deliver  #=> false (just delivers if is not a spam and is valid, raises an error in development)

  def headers
    {
      to: "get.dipen@gmail.com",
      subject:,
      from: %("#{name}" <#{email}>)
    }
  end
end
