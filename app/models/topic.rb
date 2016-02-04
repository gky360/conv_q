class Topic < ActiveRecord::Base

  validates :title,
    presence: true

  paginates_per 20

  TITLE_SPLITTTER = " ; "

  scope :rand, -> { return order("RANDOM()") }   if Rails.env === "production"
  scope :rand, -> { return order("RAND()") } unless Rails.env === "production"

end
