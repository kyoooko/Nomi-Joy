class Event < ApplicationRecord
  # ==============バリデーション ================================
  with_options presence: true do
    validates_presence_of :user_id
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


  # 【検討要】
  # def day_of_the_week(date)
  #   %w(日 月 火 水 木 金 土)[date.wday]
  # end
  # ビューに
  # <%= :day_of_the_week( @today_event.date) %>

end
