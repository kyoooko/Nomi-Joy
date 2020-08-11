class DirectMessage < ApplicationRecord
  # ==============バリデーション ================================
  validates :message, presence: true

  # ==============アソシエーション ================================
  belongs_to :user
  belongs_to :room
  # ◆通知機能
  # has_many :notifications, dependent: :destroy

  # ==================メソッド===================================
  def create_notification_dm(current_user, visited_id)
    # DMは複数回することが考えられるため、１つのDMに複数回通知することができるように制限はかけない
    notification = current_user.active_notifications.new(
      direct_message_id: id,
      visited_id: visited_id,
      action: 'dm'
    )
    notification.save if notification.valid?
  end
end
