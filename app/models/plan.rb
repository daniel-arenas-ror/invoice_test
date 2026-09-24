class Plan < ApplicationRecord
  has_many :plan_invoices, dependent: :restrict_with_error

  validates :speed, :price, presence: true
  validates :speed, :price, numericality: { only_integer: true, greater_than: 0 }
end
