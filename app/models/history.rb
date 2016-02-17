class History < ActiveRecord::Base

  belongs_to :topic
  belongs_to :user

  validates :topic_id, null: false
  validates :user_id,  null: false
  validates :topic_id,
    uniqueness: { scope: [:user_id] }

  enum rating: { like: 1, dislike: -1 }

  paginates_per 20

end
