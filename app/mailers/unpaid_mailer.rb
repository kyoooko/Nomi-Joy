class UnpaidMailer < ApplicationMailer
  def unpaid_mail(event_user)
    @event_user = event_user
    @event = Event.find(event_user.event_id)
    @admin = User.find(@event.user_id)
    user = User.find(event_user.user_id)
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "ノミカイのお支払いについてご確認のお願い", to: user.email)
  end
end
