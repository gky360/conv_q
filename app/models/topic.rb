class Topic < ActiveRecord::Base

  validates :title,
    presence: true

  paginates_per 20

  TITLE_SPLITTTER = " ; "

end
