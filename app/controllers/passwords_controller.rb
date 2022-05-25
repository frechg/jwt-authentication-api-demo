class PasswordsController < ApplicationController
  skip_before_action :require_authorization

  def create
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def find_user_for_create
    User.find_by(email: email_from_password_params)
  end

  def email_from_password_params
    params.dig(:password, :email)
  end

  def deliver_email(user)
    PasswordsMailer.password_reset(user).deliver_now 
  end

  def forgot_password!(user)
    generate_confirmation_token(user)
    user.save validate: false
  end

  def generate_confirmation_token(user)
    user.confirmation_token = SecureRandom.hex(20).encode('UTF-8')
  end
end
