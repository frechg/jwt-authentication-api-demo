require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  context 'POST /authenticate' do
    let(:user) { create(:user) }
    let(:key) { AuthorizationService::Constants::HMAC_SECRET }
    let(:algo) { AuthorizationService::Constants::ALGO_TYPE }

    it 'responds with a JWT payload containing the authenticated users id' do
      post '/authenticate', params: {
        user: { email: user.email, password: user.password }
      }

      token = JSON.parse(response.body)['token']
      payload = JWT.decode(token, key, { algorithm: algo })

      expect(response).to have_http_status(:created)
      expect(payload[0]).to eq({ 'user_id' =>  user.id })
    end

    it 'responds with users username when authentication is valid' do
      post '/authenticate', params: {
        user: { email: user.email, password: user.password }
      }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['username']).to eq(user.username)
    end

    it 'returns a error when the user does not exist' do
      post '/authenticate', params: {
        user: { email: 'person@notreal.com', password: 'password' }
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error when the user is not authorized' do
      post '/authenticate', params: {
        user: { email: user.email, password: 'wrong' }
      }

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error when the user param is missing' do
      post '/authenticate', params: { email: user.email,  password: user.password }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({
        error: 'param is missing or the value is empty: user'
      }.to_json)
    end

    it 'returns an error when the email param is missing' do
      post '/authenticate', params: { user: {  password: user.password }}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({
        error: 'param is missing or the value is empty: email'
      }.to_json)
    end

    it 'returns an error when the password param is missing' do
      post '/authenticate', params: { user: { email: user.email }}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({
        error: 'param is missing or the value is empty: password'
      }.to_json)
    end
  end
end
