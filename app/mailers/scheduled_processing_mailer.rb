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
end

