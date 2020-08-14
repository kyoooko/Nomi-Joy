class ApplicationMailer < ActionMailer::Base
  default from: 'delivery@nomijoy.com',
  # default from: "ノミジョイ！",
          bcc:      "test.kyoooko@gmail.com"
          # ,reply_to: "test.kyoooko@gmail.com"
  layout 'mailer'
end
