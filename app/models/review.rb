class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :content, presence: true, length: { minimum: 5 }
  validates :reaction, inclusion: { in: %w[позитивна нейтральна негативна], message: "%{value} не є допустимою реакцією" }
end