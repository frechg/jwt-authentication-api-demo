require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe 'before_action #require_authorization' do
    let(:user) { create(:user) }

    it 'responds with an error if the authorization token is invalid' do
      auth_token = 'notvalid'
      get(
        "/users/#{user.id}",
        headers: {authorization: "Bearer #{auth_token}"}
      )

      expect(response).to have_http_status(:unauthorized)
    end

    it 'respons with an error if user does not exist' do
      token = AuthorizationService::TokenEncoding.new({encoding_params:
        { user_id: 0 }
      }).call

      get(
        "/users/#{0}",
        headers: {authorization: "Bearer #{token}"}
      )

      expect(response).to have_http_status(:unauthorized)
    end

    it 'responds ok if the request is authorized' do
      token = AuthorizationService::TokenEncoding.new({encoding_params:
        { user_id: user.id }
      }).call
      get(
        "/users/#{user.id}",
        headers: {authorization: "Bearer #{token}"}
      )

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({
        'email' => user.email,
        'username' => user.username
      })
    end

    it 'responds with error if the profile is not the authorized users' do
      other_user = create(:user, email: 'p2@e.com', username: 'p2', password: 'pass')
      token = AuthorizationService::TokenEncoding.new({encoding_params:
        { user_id: user.id }
      }).call
      get(
        "/users/#{other_user.id}",
        headers: {authorization: "Bearer #{token}"}
      )

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
