class Tag < ActiveRecord::Base

  has_many :tag_topics
  has_many :topics, through: :tag_topics

  validates :name,
    presence: true,
    format: { with: /\A[^@,]+\z/ },
    uniqueness: true

  def self.all_with_names(tag_names)
    tags = []
    tag_names.uniq.map do |tag_name|
      next unless tag_name.present?
      tag = Tag.where(name: tag_name).first_or_create
      tags << tag if tag.persisted?
    end
    return tags
  end

end
