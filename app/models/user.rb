class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings
  has_many :rooms, through: :bookings

  enum role: { user: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  def admin?
    role == 'admin'
  end
end
