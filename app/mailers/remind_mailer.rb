class RemindMailer < ApplicationMailer
  def remind_mail(event)
    @event = event
    @admin = User.find(@event.user_id)
    participants = User.includes(:event_users).where(event_users: {event_id: @event.id})
    @participant_mails = participants.pluck(:email)
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "【リマインド】ノミカイが近づいています", bcc: @participant_mails)
  end
end
