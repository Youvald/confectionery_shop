class Feedback < ApplicationRecord
  belongs_to :user
  attribute :hidden_for_admin, :boolean, default: false
  validates :content, presence: true, length: { minimum: 5 }
end
