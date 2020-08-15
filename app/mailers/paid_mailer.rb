class PaidMailer < ApplicationMailer
  def paid_mail(event_user)
    @event_user = event_user
    @event = Event.find(event_user.event_id)
    @admin = User.find(@event.user_id)
    user = User.find(event_user.user_id)
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "ノミカイの会費を領収しました", to: user.email)
  end
end
