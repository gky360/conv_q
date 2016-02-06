class History < ActiveRecord::Base

  belongs_to :topic
  belongs_to :user

end
