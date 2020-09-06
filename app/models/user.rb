class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20, minimum: 2 }, uniqueness: true
  validates :introduction, length: { maximum: 1000 }

  attachment :profile_image, destroy: false

  enum gender: { ' ': 0, 女性: 1, 男性: 2, その他: 3 }
  enum status: { 'ー': 0, 家族: 1, 一人暮らし: 2, シェア: 3, カップル: 4, その他: 5 }, _prefix: :status

  enum age: {
    'ー': 0, '10代': 1, '20代': 2, '30代': 3, '40代': 4,
    '50代': 5, '60代': 6, '70代': 7, '80代': 8, 'その他': 9,
  }, _prefix: :age

  enum layout: {
    'ー': 0, '1R': 1, '1K': 2, '1DK': 3, '1LDK': 4,
    '2K': 5, '2DK': 6, '2LDK': 7, '3K': 8, '3DK': 9,
    '3LDK': 10, '4K': 11, '4DK': 12, '4LDK': 13, 'その他': 14,
  }, _prefix: :layout

  enum area: {
    'ー': 0, '~15㎡': 1, '15~20㎡': 2, '20~25㎡': 3, '25~30㎡': 4,
    '30~35㎡': 5, '35~40㎡': 6, '40~45㎡': 7, '45~50㎡': 8, '50~60㎡': 9,
    '60~70㎡': 10, '70~80㎡': 11, '80~90㎡': 12, '90~100㎡': 13, '100~200㎡': 14,
    '200~300㎡': 15, '300~400㎡': 16, '400~500㎡': 17, '500㎡~': 18,
  }, _prefix: :area
end
