require 'rails_helper'

RSpec.describe AuthorizationTokenService  do
  context '.call' do
    let(:user) { create(:user) }

    it 'returns JWT authorization token with a user id in the payload' do
      encoded_token = described_class.encode(user.id)
      decoded_token = JWT.decode(
        encoded_token,
        described_class::HMAC_SECRET,
        true,
        { algorithm: described_class::ALGO_TYPE }
      )
      token_payload = decoded_token[0]['user_id']

      expect(token_payload).to eq(user.id)
    end
  end
end
