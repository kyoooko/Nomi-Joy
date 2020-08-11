class EventUser < ApplicationRecord
  # paranoia
  acts_as_paranoid

  # ==============アソシエーション ================================
  belongs_to :user
  belongs_to :event

  # ==============バリデーション ================================
  # feeは半角英数字（integerなので下記記載なくても０になる)
  validates :fee, format: { with: /\A[a-zA-Z0-9]+\z/ }
end
