require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'POST /passwords' do
    let(:user) { create(:user) }

    it 'sends a password reset email' do
      post '/passwords', params: {
        password: { email: user.email }
      }
    end

    it 'saves a confirmation_token on the user' do
      post '/passwords', params: {
        password: { email: user.email }
      }

      expect(user.confirmation_token).not_to eq(nil)
    end

    it 'responds with an error if the email param is missing' do
    end

    it 'responds with an error if the user does not exist' do
    end

    it 'responds with an error if the email does not send' do
    end
  end
end
