class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # フォローされる側の関係性
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 上記の関係を通じて参照（自分をフォローしている人）
  has_many :followers, through: :followed, source: :follower
  
  # フォローする側の関係性
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 上記の関係を通じて参照（自分がフォローしている人）
  has_many :followings, through: :follower, source: :followed
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  # コントローラーでも使用する定義
  def follow(user)
    follower.create(followed_id: user.id)
  end
  
  def unfollow(user)
    follower.find_by(follow_id: user.id).destroy
  end 
  
  def following?(user)
    followings.include?(user)
  end
end
