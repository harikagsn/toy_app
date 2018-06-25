class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, length: { maximum: 120}, presence: true
end
