class ApplicationMailer < ActionMailer::Base
  default from: "\"CQ Manager Admin\" <admin@codequest-manager.herokuapp.com>"
  layout "mailer"
end
