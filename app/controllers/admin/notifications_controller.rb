class Admin::NotificationsController < ApplicationController
  def index
    # 下記includesの前にwhere(checked: false)記述すると一度も見れなくなってしまう
    # includesはN+1問題の解消
    notifications = current_user.passive_notifications.eager_load([:visitor, :visited])

    
    # 【いる？】自分でした自分の投稿に対するいいね、コメントは通知に表示しない
    @notifications = notifications.where.not(visitor_id: current_user.id).page(params[:page]).per(15)
    # indexページを開くとchecked: trueに変更（これは未通知の場合のアイコン表示に使用）
    notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
