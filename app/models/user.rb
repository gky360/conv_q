class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :histories,
    dependent: :destroy
  has_many :topics,
    dependent: :nullify

  NAME_EXCLUSION_LIST = [
    # actions
    'index', 'show', 'new', 'create', 'edit', 'update', 'destroy',
    # devise
    'sign_in', 'sign_out', 'password', 'cancel', 'sign_up', 'edit', 'confirmation', 'unlock', 'auth',
    # others
    'account', 'config', 'configs', 'setting', 'settings'
  ]

  validates :name,
    presence: true
  validates :account,
    presence: true,
    uniqueness: true,
    format: { with: /\A[a-z0-9_]{1,24}\z/ },
    exclusion: { in: NAME_EXCLUSION_LIST }

  enum status: Hash[
    admin:   1 << 5,
    default: 0
  ]

end
