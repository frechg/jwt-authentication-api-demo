class User < ApplicationRecord
  has_secure_password
  validates :username, :email, presence: true
  validates :email, uniqueness: true

  def forgot_password!
    generate_confirmation_token
    save validate: false
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(20).encode('UTF-8')
  end
end
