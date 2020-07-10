class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  #devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Refile 
  attachment :image
  # ==============バリデーション ================================
  validates :name, presence: true
  validates :email, presence: true
  validates :introduction, presence: true

  # ==============アソシエーション ================================
  # ◆マッチング機能
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

  # ◆ダイレクトメッセージ機能
  has_many :entries
  has_many :direct_messages
  has_many :users, through: :entries

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
    self.where("nomi_joy_id =?", "#{word}")
  end
  
end
