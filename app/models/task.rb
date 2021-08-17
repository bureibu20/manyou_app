class Task < ApplicationRecord
  validates :title, presence: true, length:{ maximum:25}
  validates :content, presence: true, length: { maximum: 150 }
  validates :expired_at, presence: true
end
