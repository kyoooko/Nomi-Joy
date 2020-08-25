class Event < ApplicationRecord
  # ==============バリデーション ================================
  # user_id,restaurant_idはコントローラーで代入、progress_status,fee_statusはデフォルトで設定あり
  with_options presence: true do
    validates :name
    validates :date
    validates :begin_time
    validates :finish_time
  end

  # ==============アソシエーション ================================
  # ◆飲食店
  belongs_to :restaurant, optional: true
  # ◆ノミカイユーザー（中間テーブル）
  has_many :event_users, dependent: :destroy
  # ◆通知
  has_many :notifications, dependent: :destroy

  # ==================メソッド=====================================
  # ◆カレンダー：gem simple_calendarでは"start_time"と"end_time"ベースでカレンダーのdayに入る。今回は日付と時間の入力を分けており、時間カラムには今日に日付が入ってしまうため、simple_calendarの仕様踏まえて明示的にstart_timeとend_timeを日付カラムの日にちに設定しなければならない。そのため開始時間と終了時間の命名をかぶらないようにbegin_timeとfinish_timeにした。
  def start_time
    date
  end

  def end_time
    date
  end

  # ◆通知機能（未払いのメンバーへの支払い依頼）
  def create_notification_require_fee(current_user, visited_id)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: visited_id,
      action: 'require_fee'
    )
    notification.save if notification.valid?
  end

  # ◆通知機能（新規ノミカイ案内）
  def create_notification_new_event(current_user, visited_id)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: visited_id,
      action: 'create_event'
    )
    # 自分へは通知が作られない・届かないようにする
    notification.save if notification.visitor_id != notification.visited_id && notification.valid?
  end

  # ◆通知機能（リマインド）
  def create_notification_remind_event(current_user, visited_id)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: visited_id,
      action: 'remind_event'
    )
    # 自分へは通知が作られない・届かないようにする
    notification.save if notification.visitor_id != notification.visited_id && notification.valid?
  end

  # ◆通知機能（領収済）
  def create_notification_paid_fee(current_user, visited_id)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: visited_id,
      action: 'paid_fee'
    )
    notification.save if notification.valid?
  end
end
