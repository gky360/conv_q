class TagTopic < ActiveRecord::Base

  belongs_to :tag
  belongs_to :topic

  validates :tag_id,
    presence: true
  validates :topic_id,
    presence: true

end
