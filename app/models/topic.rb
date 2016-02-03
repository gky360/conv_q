class Topic < ActiveRecord::Base

  validates :title,
    presence: true

  TITLE_SPLITTTER = " ; "

end
