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

  describe 'GET /users/:user_id/password/edit' do
    let(:user) { create :user }

    it 'renders a password reset form with user id and token params' do
      user.update(confirmation_token: '123')
      get edit_user_password_path(user), params: {
        token: '123'
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.confirmation_token)
    end

    it '' do
    end
  end
end
