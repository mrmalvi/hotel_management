class Platform < ApplicationRecord
  has_many :hotels, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates :enable_mail, inclusion: { in: [true, false] }
end 