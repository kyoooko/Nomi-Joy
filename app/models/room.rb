class Room < ApplicationRecord
   # ◆ダイレクトメッセージ機能
  has_many :entries
  has_many :direct_messages
  has_many :rooms, through: :entries
end
