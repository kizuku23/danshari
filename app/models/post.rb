class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
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

  def self.sort(selection)
    case selection
    when 'new'
      order(created_at: :DESC)
    when 'old'
      order(created_at: :ASC)
    when 'likes'
      joins(:likes).group(:post_id).order('count(post_id) desc')
    end
  end
end
