class Payment < ApplicationRecord
  belongs_to :booking

  validates :amount, :booking_id, :status, presence: true
end
