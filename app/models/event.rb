class Event < ApplicationRecord
  # ==============バリデーション ================================
  # user_id,restaurant_idはコントローラーで代入、progress_status,fee_statusはデフォルトで設定あり
  with_options presence: true do
    validates :name
    validates :date
    validates :start_time
    validates :end_time
    validates :start_time
  end

  # ==============アソシエーション ================================
  # ◆飲食店
  belongs_to :restaurant, optional: true
  # ◆ノミカイユーザー（中間テーブル）
  has_many :event_users, dependent: :destroy
  # ◆ユーザー（中間テーブルを介す）
  has_many :users, through: :event_users
  # 【確認要】 ◆ユーザー（中間テーブル介さない、幹事とノミカイの関係性）
  # belongs_to :admin_user,class_name:"User"
  # ◆通知
  has_many :notifications, dependent: :destroy

  # カレンダー：gem simple_calendarでは"start_time"ベースでカレンダーのdayに入るため、今回はdateカラムをstart_timeに設定する
  def start_time
    self.date
  end

  # 通知機能（未払いのメンバーへの一斉支払い確認通知）
  def create_notification_require_fee(current_user,visited_id)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: visited_id,
      action: 'require_fee'
    )
    notification.save if notification.valid?
  end
end
