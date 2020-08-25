class Public::NotificationsController < ApplicationController
  def index
    # where(checked: false)記述すると一度も見れなくなってしまう
    # N+1問題の解消
    notifications = current_user.passive_notifications.includes([:event]).eager_load([:visitor, :visited])
    # .includes([:direct_message]).
    @notifications = notifications.page(params[:page]).per(15)
    # indexページを開くとchecked: trueに変更（これは未通知の場合のアイコン表示に使用）
    notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
