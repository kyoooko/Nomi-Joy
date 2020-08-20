class ScheduledProcessingMailer < ApplicationMailer
  # バッチ（定時）処理
  # 未読通知が3件以上たまるとメール自動送信
  def check_notice_mail
    @url = "https://nomi-joy.com/users/sign_in"
    # selectは返り値が真の要素を集めた配列を返す
    users_with_unckecked_notices = User.all.select do |user|
      user.passive_notifications.where(visited_id: user.id, checked: false).count >= 3
    end
    users_with_unckecked_notices_mails = users_with_unckecked_notices.pluck(:email)
    mail(subject: "未読の通知が3件以上あります", bcc: users_with_unckecked_notices_mails)
  end
  
  def before_1day_remind_mail
    @url = "https://nomi-joy.com/users/sign_in"
    @events = Event.all
    @events.each do |event|
      # 下記確認!!!!!!!!!!!!!!!!!!!!!!!!
      if event.date - 1.day <  Time.now
        # where.notでカンジ本人にはメールが行かないようにする
        @admin = User.find(event.user_id)
        participants = User.includes(:event_users).where(event_users: {event_id: event.id}).where.not(id: @admin.id)
        participant_mails = participants.pluck(:email)
        mail(subject: "【リマインド】明日ノミカイの予定があります！", bcc: participant_mails)
      end
    end
  end
end


