class Sale < ApplicationRecord
  belongs_to :client

  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validates :sold_at, presence: true
end
