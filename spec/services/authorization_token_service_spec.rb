require 'rails_helper'

RSpec.describe AuthorizationTokenService  do
  let(:user) { create(:user) }

  context '#encode' do
    it 'returns a JWT authorization token with the provided payload' do
      encoded_token = described_class.encode({ data: '123' })
      decoded_payload = JWT.decode(
        encoded_token,
        described_class::HMAC_SECRET,
        true,
        { algorithm: described_class::ALGO_TYPE }
      )

      expect(decoded_payload[0]['data']).to eq('123')
    end
  end

  context '#decode' do
    it 'returns the payload of a valid JWT' do
      token = JWT.encode(
        { data: '123' },
        described_class::HMAC_SECRET,
        described_class::ALGO_TYPE
      )
      token_payload = described_class.decode(token)

      expect(token_payload[0]['data']).to eq('123')
    end

    it 'raises an error when the JWT is not valid' do
      token = '123invalid'

      expect { described_class.decode(token) }.to raise_error(JWT::DecodeError)
    end
  end
end
