class Topic < ActiveRecord::Base

  has_many :histories
  has_many :users, through: :histories

  validates :title,
    presence: true
  validates :topic_id,
    uniqueness: { scope: [:user_id] }

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
      return Topic.includes(:histories).rand
    end
    histories = user.histories
    average_times = histories.average(:times)
    topic_ids = Topic.joins(:histories)
      .merge(History.where(user_id: user.id).where("times > ?", average_times)).ids
    return Topic.includes(:histories).where.not(id: topic_ids).rand
  end

end
