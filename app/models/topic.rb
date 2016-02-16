class Topic < ActiveRecord::Base

  has_many :histories
  has_many :users, through: :histories
  has_many :tag_topics
  has_many :tags, through: :tag_topics

  validates :title,
    presence: true

  paginates_per 20

  TITLE_SPLITTTER = " ; "

  scope :rand, -> { order("RANDOM()") }   if Rails.env === "production"
  scope :rand, -> { order("RAND()") } unless Rails.env === "production"

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
    topics = Topic.where("`title` LIKE ?", "%#{q[:title]}%")
    if q[:tag_names]
      q[:tag_names].split(",").each do |tag_name|
        tag = Tag.find_by(name: tag_name)
        next if tag.nil?
        topics = topics.where(id: tag.topic_ids)
      end
    end

    return topics
  end

end
