class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  STATUSES = %w[pending paid].freeze

  validates :status, inclusion: { in: STATUSES }
end
