class Topic < ActiveRecord::Base

  has_many :histories,
    dependent: :destroy
  has_many :tag_topics,
    dependent: :destroy
  has_many :tags, through: :tag_topics
  has_many :reports,
    dependent: :destroy
  belongs_to :user

  validates :title,
    presence: true
  validates :source_url,
    allow_blank: true,
    format:{ with: /\A#{URI::regexp(%w(http https))}\z/ }

  paginates_per 20

  TITLE_SPLITTTER = "\n  ; "

  scope :rand, -> { order("RAND()") }

  def ratings
    return @ratings if @ratings

    @ratings = {}
    @ratings[:total] = 0
    History.ratings.each do |key, val|
      key = key.to_sym
      @ratings[key] = histories.where(rating: val).count
      @ratings[:total] += @ratings[key]
    end

    return @ratings
  end

  def self.rand_for_user(user)
    if user.nil?
      return Topic.includes(:tags, :histories).rand
    end
    histories = user.histories
    average_times = histories.average(:times)
    topic_ids = Topic.joins(:histories)
      .merge(History.where(user_id: user.id).where("times > ?", average_times)).ids
    return Topic.includes(:tags, :histories).where.not(id: topic_ids).rand
  end

  def self.search(q)
    topics = Topic.all
    q[:title] ||= ""
    q[:title].split(/[ ,]+/).each do |title|
      topics = topics.where("`title` LIKE ?", "%#{title}%")
    end
    q[:tag_names].split(",").each do |tag_name|
      tag = Tag.find_by(name: tag_name)
      next if tag.nil?
      topics = topics.where(id: tag.topic_ids)
    end

    return topics
  end

  def by_user?(user)
    return false if user.nil?
    return user_id === user.id
  end

end
