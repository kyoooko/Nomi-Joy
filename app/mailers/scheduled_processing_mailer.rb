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
    # ============================================
    # 該当するノミカイのみ配列で取得
    before_1day_events = Event.all.select do |event|
      @event = event
      (Time.current - 1.day < @event.date) && (@event.date < Time.current)
    end
    before_1day_events_emails = before_1day_events .map do |before_1day_event|
      @admin = User.find(before_1day_event.user_id)
      # 通知
      @event_users = EventUser.where(event_id: before_1day_event.id)
      @event_users.each do |event_user|
        before_1day_event.create_notification_remind_event(@admin, event_user.user_id)
      end
      # 送信するメールアドレス
      participants = User.includes(:event_users).where(event_users: { event_id: before_1day_event.id }).where.not(id: @admin.id)
      participant_mails = participants.pluck(:email)
    end
    # before_1day_events_emailsは[["メールアドレス1", "メールアドレス2"], ["メールアドレス3", "メールアドレス4", "メールアドレス1"]]の状態
    emails = []
    before_1day_events_emails.each do |array_emails|
      array_emails.each do |array_email|
        emails << array_email
      end
    end
    # emailsは["メールアドレス1", "メールアドレス2", "メールアドレス3", "メールアドレス4", "メールアドレス1"]の状態
    # 重複しているアドレスは１回しか送信されない
    mail(subject: "【リマインド】明日招待されているノミカイがあります！", bcc: emails) # ============================================
    # 下記だと、最後の配列の参加者にしかメールが行かない
    # events.each do |event|
    #   # 定時処理で毎朝8:00に該当のノミカイの参加メンバーにメールが送信される
    #   @event = event
    #   if (Time.current - 1.day < @event.date) && (@event.date <  Time.current)
    #     # where.notでカンジ本人にはメールが行かないようにする
    #     @admin = User.find(@event.user_id)
    #     participants = User.includes(:event_users).where(event_users: {event_id: @event.id}).where.not(id: @admin.id)
    #     participant_mails = participants.pluck(:email)
    #     mail(subject: "【リマインド】明日招待されているノミカイがあります！", bcc: participant_mails)
    #   end
    # end
  end
end
