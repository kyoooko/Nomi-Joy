class InvitationMailer < ApplicationMailer
  def invitation_mail(event)
    @event = event
    @admin = User.find(@event.user_id)
    # where.notでカンジ本人にはメールが行かないようにする
    participants = User.includes(:event_users).where(event_users: { event_id: @event.id }).where.not(id: @admin.id)
    @participant_mails = participants.pluck(:email)
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "ノミカイに招待されました", bcc: @participant_mails)
  end

  # 参加者を追加した場合の追加メンバーへのメール
  def invitation_mail_for_add_participant(event, add_event_users)
    @event = event
    @admin = User.find(@event.user_id)
    add_participants = add_event_users.map do |add_event_user|
      User.find(add_event_user.user_id)
    end
    @participant_mails = add_participants.pluck(:email)
    @url = "https://nomi-joy.com/users/sign_in"
    mail(subject: "ノミカイに招待されました", bcc: @participant_mails)
  end
end
