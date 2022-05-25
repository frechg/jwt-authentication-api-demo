require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  describe 'POST /passwords' do
    let(:user) { create(:user) }

    it 'sends a password reset email' do
      post '/passwords', params: {
        password: { email: user.email }
      }

      expect(response).to have_http_status(:created)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'responds with an error if the email param is missing' do
      post '/passwords', params: {
        password: { email: '' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'responds with an error if the user does not exist' do
      post '/passwords', params: {
        password: { email: 'notreal@fake.com' }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
