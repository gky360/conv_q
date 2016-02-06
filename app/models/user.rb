class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name,
    presence: true
  validates :account,
    presence: true,
    uniqueness: true,
    format: { with: /\A[a-z0-9_]{1,24}\z/ }

end
