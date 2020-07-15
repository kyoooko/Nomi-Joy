class Restaurant < ApplicationRecord
  # ◆飲食店
  has_many :events
  # ◆ユーザー
  belongs_to :user
end
