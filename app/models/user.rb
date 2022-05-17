class User < ApplicationRecord
  has_secure_password
  validates :user_name, :email, presence: true
  validates :email, uniqueness: true
end
