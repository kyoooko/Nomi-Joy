class Restaurant < ApplicationRecord
  # ぐるなびAPIでお店を選択すれば店名など必須項目は自動に入力されるためバリデーション記載せず
  # ◆飲食店
  has_many :events
  # ◆ユーザー
  belongs_to :user
end
