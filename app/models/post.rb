class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validates :image, presence: true
  validates :description, length: {maximum: 1000}

  attachment :image
end
