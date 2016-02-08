class History < ActiveRecord::Base

  belongs_to :topic
  belongs_to :user

  validates :topic_id, null: false
  validates :user_id,  null: false

  enum rating: { like: 1, dislike: -1 }

end
