class Topic < ActiveRecord::Base

  has_many :histories
  has_many :users, through: :histories

  validates :title,
    presence: true

  paginates_per 20

  TITLE_SPLITTTER = " ; "

  scope :rand, -> { return order("RANDOM()") }   if Rails.env === "production"
  scope :rand, -> { return order("RAND()") } unless Rails.env === "production"

end
