class Asset < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :image

  validates :image, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  scope :ordered, -> { order(position: :asc) }

  def main_image?
    position == 1
  end
end
