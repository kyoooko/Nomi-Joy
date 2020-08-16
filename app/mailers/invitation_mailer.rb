class InvitationMailer < ApplicationMailer
  def invitation_mail(event)
    @event = event
    @admin = User.find(@event.user_id)
    participants = User.includes(:event_users).where(event_users: {event_id: @event.id}).where.not(id: @admin.id)
    @participant_mails = participants.pluck(:email)
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "ノミカイに招待されました", bcc: @participant_mails)
  end
end
