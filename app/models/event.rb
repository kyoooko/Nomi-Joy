class Event < ApplicationRecord
  # ◆飲食店
  belongs_to :restaurant
  # ◆ノミカイユーザー（中間テーブル）
  has_many :event_users, dependent: :destroy
  # ◆ユーザー（中間テーブルを介す）
  has_many :users, through: :event_users
  # 下記間違ってるかも
  # # ◆ユーザー（中間テーブル介さない、幹事とノミカイの関係性）
  # belongs_to :admin_users,class_name:"User"
end
