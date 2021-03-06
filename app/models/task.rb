class Task < ApplicationRecord
  validates :title, presence: true, length:{ maximum:25}
  validates :content, presence: true, length: { maximum: 150 }
  validates :expired_at, presence: true
  enum status: { 未着手:0, 着手中:1, 完了:2 }
  enum priority: {低:0, 中:1, 高:2}
  scope :search_title, -> (title) { where("title LIKE ?", "%#{title}%") }
  scope :search_status, -> (status) { where(status: status)}
  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings
end
