class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
     
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :email, presence: true
  validates :introduction, length: { maximum: 50 }
        
  # attachment :profile_image
end
