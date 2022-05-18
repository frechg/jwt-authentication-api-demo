require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  context 'POST /authenticate' do
    it 'authenticates the client' do
      post '/authenticate', params: { user: { username: 'person', password: 'testingpass' }}

      expect(response).to have_http_status(:created)
      expect(response.body).to eq({token: '123'}.to_json)
    end

    it 'returns an error when the user key is missing' do
      post '/authenticate', params: { username: 'person',  password: 'testingpass' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({
        error: 'param is missing or the value is empty: user'
      }.to_json)
    end

    it 'returns an error when the username is missing' do
      post '/authenticate', params: { user: {  password: 'testingpass' }}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({
        error: 'param is missing or the value is empty: username'
      }.to_json)
    end

    it 'returns an error when the password is missing' do
      post '/authenticate', params: { user: { username: 'person' }}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq({
        error: 'param is missing or the value is empty: password'
      }.to_json)
    end
  end
end
