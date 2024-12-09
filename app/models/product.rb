class Product < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one_attached :image
  validates :weight, presence: true, numericality: { greater_than: 0 }
end
