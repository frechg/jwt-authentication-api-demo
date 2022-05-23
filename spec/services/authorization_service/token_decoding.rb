require 'rails_helper'

RSpec.describe AuthorizationService::TokenDecoding  do
  let(:user) { create(:user) }
  let(:secret) { AuthorizationService::Constants::HMAC_SECRET }
  let(:algo) { AuthorizationService::Constants::ALGO_TYPE }

  it 'returns the payload of a valid JWT' do
    token = JWT.encode(
      { data: '123' },
      secret,
      algo
    )
    payload = described_class.decode(token)

    expect(token_payload[0]['data']).to eq('123')
  end

  it 'raises an error when the JWT is not valid' do
    token = '123invalid'

    expect { described_class.decode(token) }.to raise_error(JWT::DecodeError)
  end
end

