class ApplicationMailer < ActionMailer::Base
  default from: "\"Lunchiatto Admin\" <admin@lunchiatto.com>"
  layout 'mailer'
end
