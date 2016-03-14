class Report < ActiveRecord::Base

  belongs_to :topic
  belongs_to :user

  REASONS = Hash[
    0 => "The title has some grammatical errors.",
    1 => "The title is difficult to understand.",
    2 => "The title is inappropriate.",
    3 => "The tags are inappropriate.",
    4 => "The source URL is inappropriate."
  ].freeze
  DETAIL_MAX_LENGTH = 1000

  validates :topic_id, null: false
  validates :user_id,  null: false
  validates :topic_id,
    uniqueness: { scope: [:user_id] }
  validates :reason_flag,
    numericality: { greater_than: 0, message: ": At least one of the reasons should be selected." }
  validates :detail,
    length: { maximum: DETAIL_MAX_LENGTH }

  def reasons
    reasons_h = {}
    REASONS.each do |reason_value, reason_text|
      if reason_flag & (1 << reason_value) > 0
        reasons_h[reason_value] = reason_text
      end
    end
    return reasons_h
  end

  # save はしないので、レコードを更新したい場合は別途呼ぶ必要がある
  def reasons=(reasons_h)
    reasons_h ||= {}
    self.reason_flag = 0
    reasons_h.keys.each do |reason_value|
      reason_value = reason_value.to_i
      self.reason_flag = self.reason_flag | (1 << reason_value)
      p self.reason_flag
    end
  end

  def by_user?(user)
    return false if user.nil?
    return user_id === user.id
  end

end
