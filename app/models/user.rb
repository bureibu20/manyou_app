class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_many :tasks, dependent: :destroy

  before_destroy :admin_exist_check
  before_update :admin_exist_check_update
  def admin_exist_check
    throw :abort if self.admin? && User.where(admin: true).count == 1
  end
  def admin_exist_check_update
    @admin_user = User.where(admin: true)
    throw :abort if @admin_user.first == self && @admin_user.count == 1
  end
end
