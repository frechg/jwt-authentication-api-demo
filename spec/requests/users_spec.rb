require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /signup' do
    it 'creates a new user and JWT given valid username, email and password' do
      allow_any_instance_of(AuthorizationService::TokenEncoding).to(
        receive(:call).and_return('123')
      )

      post(
        '/signup',
        params: {
          new_user: {
            username: 'person',
            email: 'person@example.com',
            password: 'testingpass'
          }
        }
      )

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({
        'username' => 'person',
        'token' => '123'
      })
    end

    it 'respons with an error if new_user param is missing' do
      post(
        '/signup',
        params: {
          username: 'person',
          email: 'person@example.com',
          password: 'testingpass'
        }
      )

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'error' => 'param is missing or the value is empty: new_user',
      })
    end

    it 'respons with an error if username is missing' do
      post(
        '/signup',
        params: {
          new_user: {
            email: 'person@example.com',
            password: 'testingpass'
          }
        }
      )

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'error' => 'param is missing or the value is empty: username',
      })
    end

    it 'respons with an error if email is missing' do
      post(
        '/signup',
        params: {
          new_user: {
            username: 'person',
            password: 'testingpass'
          }
        }
      )

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'error' => 'param is missing or the value is empty: email',
      })
    end

    it 'respons with an error if password is missing' do
      post(
        '/signup',
        params: {
          new_user: {
            username: 'person',
            email: 'person@example.com'
          }
        }
      )

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'error' => 'param is missing or the value is empty: password',
      })
    end

    it 'respons with an error if the email is already registered' do
      user = create(:user, email: 'person@example.com')
      post(
        '/signup',
        params: {
          new_user: {
            username: 'person',
            email: 'person@example.com',
            password: 'testingpass'
          }
        }
      )

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({
        'errors' => ['Email has already been taken'],
      })
    end
  end
end
