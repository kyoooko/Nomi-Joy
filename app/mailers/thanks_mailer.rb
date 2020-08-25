class ThanksMailer < ApplicationMailer
  default bcc: "test.kyoooko@gmail.com"

  def thanks_mail(user)
    @user = user
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "ご登録が完了しました", to: @user.email)
    # @attachments.inline['image.jpg'] = File.read('./app/assets/images/twitter-card.png.JPG', ?r)
  end
end
