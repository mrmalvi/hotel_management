class Hotel < ApplicationRecord
  belongs_to :platform
  has_many :rooms, dependent: :destroy
  has_many :hotel_amenities, dependent: :destroy
  has_many :amenities, through: :hotel_amenities
  has_many :assets, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :star_rating, numericality: { in: 1..5 }
  
  scope :by_location, ->(location) { where("address ILIKE ?", "%#{location}%") }
  scope :by_amenities, ->(amenity_ids) { joins(:amenities).where(amenities: { id: amenity_ids }).distinct }
  scope :by_rating, ->(rating) { where(star_rating: rating) }
  
  def main_image
    assets.order(position: :asc).first&.image
  end
end 