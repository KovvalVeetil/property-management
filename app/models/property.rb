class Property < ApplicationRecord
  belongs_to :user
  has_many :bookings

  validates :title, :description, :price, :location, presence: true
end
