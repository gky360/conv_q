class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :histories
  has_many :topics

  NAME_EXCLUSION_LIST = [
    # actions
    'index', 'show', 'new', 'create', 'edit', 'update', 'destroy',
    # devise
    'sign_in', 'sign_out', 'password', 'cancel', 'sign_up', 'edit', 'confirmation', 'unlock', 'auth',
    # others
    'account'
  ]

  validates :name,
    presence: true
  validates :account,
    presence: true,
    uniqueness: true,
    format: { with: /\A[a-z0-9_]{1,24}\z/ },
    exclusion: { in: NAME_EXCLUSION_LIST }

end
