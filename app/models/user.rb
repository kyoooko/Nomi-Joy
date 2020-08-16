class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Refile
  attachment :image

  # ==============バリデーション ================================
  with_options presence: true do
    validates :name
    validates :email
  end
  # ノミジョイ！IDは半角英数字（大文字も可能）、６文字以上
  validates :nomi_joy_id, length: { minimum: 6 }, format: { with: /\A[a-zA-Z0-9]+\z/ }
  #  備考：パスワードデフォルトで６文字以上を要求している
  #  備考：メールアドレスはデフォルトで一意であることを要求している
  # ==============アソシエーション ================================
  # ◆マッチング機能（自己結合型多対多）
  # A：自分がフォローしているユーザーとの関連
  # フォローする場合の中間テーブルを「active_relationships」と名付ける。外部キーは「following_id」
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  # 中間テーブルを介してfollowerモデル（＝フォローされた側のUser)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower

  # B：自分がフォローされるユーザーとの関連
  # フォローする場合の中間テーブルを「passive_relationships」と名付ける。外部キーは「follower_id」
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  # 中間テーブルを介してfollowingモデル(=フォローする側のUser)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following

  # ◆ダイレクトメッセージ機能（中間テーブル/1対多）
  has_many :entries
  has_many :direct_messages
  # has_many :rooms, through: :entries

  # ◆飲食店（1対多）
  has_many :restaurants, dependent: :destroy
  # ◆ノミカイユーザー（中間テーブル/1対多）
  has_many :event_users, -> { with_deleted }, dependent: :destroy
  # ◆ノミカイ（中間テーブルを介す/多対多）
  has_many :events, through: :event_users

  # ◆通知機能（自己結合型多対多）
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  # ◆ToDoリスト（１対多）
  has_many :todos

  # ==================メソッド===================================
  # ◆マッチング機能
  # follow済みかどうか判定（引数のuserには自分を入れる）
  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  # マッチングしたユーザー（＝「メンバー」となる）
  def matchers
    followings & followers
  end

  # ◆検索機能（部分検索）
  def self.search(word)
    where("nomi_joy_id =?", "#{word}")
  end

  # ◆通知機能
  def create_notification_followed_by(current_user)
    # 「連続でフォローボタンを押す」ことに備えて、同じ通知レコードが存在しないときだけ、レコードを作成
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
