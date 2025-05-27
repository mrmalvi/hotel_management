class Room < ApplicationRecord
  belongs_to :hotel
  belongs_to :room_type
  has_many :room_amenities, dependent: :destroy
  has_many :amenities, through: :room_amenities
  has_many :bookings, dependent: :destroy
  has_many :assets, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  validates :room_type, presence: true
  validates :price_per_night, presence: true, numericality: { greater_than: 0 }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :max_adults, presence: true, numericality: { greater_than: 0 }
  validates :max_children, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :available_for_dates, ->(check_in, check_out) {
    where.not(id: Booking.where('check_in <= ? AND check_out >= ?', check_out, check_in).select(:room_id))
  }

  scope :by_capacity, ->(adults, children) {
    where('max_adults >= ? AND max_children >= ?', adults, children)
  }

  scope :by_type, ->(type) { joins(:room_type).where(room_types: { name: type }) }
  scope :by_price_range, ->(min, max) { where(price_per_night: min..max) }

  def available_for_dates?(check_in, check_out)
    !bookings.exists?('check_in <= ? AND check_out >= ?', check_out, check_in)
  end

  def main_image
    # assets.ordered.first.&.image&.attached?
    false
  end
end
