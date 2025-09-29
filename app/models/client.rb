class Client < ApplicationRecord
  include Filterable

  has_many :sales, dependent: :destroy

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true

  scope :filter_by_name, ->(name) { where("full_name ILIKE ?", "%#{name}%") }
  scope :filter_by_email, ->(email) { where("email ILIKE ?", "%#{email}%") }
end
