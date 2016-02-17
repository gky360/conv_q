class Tag < ActiveRecord::Base

  has_many :tag_topics
  has_many :topics, through: :tag_topics

  validates :name,
    presence: true,
    uniqueness: true

end
