require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe 'before_action #require_authorization' do
    let(:user) { create(:user) }

    it 'responds with an error if authorization token is invalid' do
      auth_token = 'notvalid'
      get(
        "/users/#{user.id}",
        headers: {authorization: "Bearer #{auth_token}"}
      )

      expect(response).to have_http_status(:unauthorized)
    end

    it 'respons with error if user does not exist' do
      user_id = 0
      auth_token = AuthorizationTokenService.call(user_id)
      get(
        "/users/#{000}",
        headers: {authorization: "Bearer #{auth_token}"}
      )

      expect(response).to have_http_status(:unauthorized)
    end

    it 'responds ok if the request is authorized' do
      auth_token = AuthorizationTokenService.call(user.id)
      get(
        "/users/#{user.id}",
        headers: {authorization: "Bearer #{auth_token}"}
      )

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({
        'email' => user.email,
        'username' => user.username
      })
    end

    it 'responds with error if the profile is not the authorized users' do
      user_two = create(:user, email: 'p2@e.com', username: 'p2', password: 'pass')
      auth_token = AuthorizationTokenService.call(user.id)
      get(
        "/users/#{user_two.id}",
        headers: {authorization: "Bearer #{auth_token}"}
      )

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
