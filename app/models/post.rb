class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validates :image, presence: true
  validates :description, length: { maximum: 1000 }

  attachment :image

  acts_as_taggable

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def Post.search(search, user_or_post)
    if user_or_post == "1"
      Post.where(['description LIKE ?', "%#{search}%"])
    else
      Post.all
    end
  end
end
