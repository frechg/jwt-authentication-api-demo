require 'rails_helper'

RSpec.describe AuthorizationService::TokenEncoding  do
  let(:user) { create(:user) }
  let(:secret) { AuthorizationService::Constants::HMAC_SECRET }
  let(:algo) { AuthorizationService::Constants::ALGO_TYPE }

  it 'returns a JWT authorization token with the provided payload' do
    token = described_class.new({encoding_params:
      { data: '123' }
    }).call

    decoded_payload = JWT.decode(
      token,
      secret,
      true,
      { algorithm: algo }
    )

    expect(decoded_payload[0]['data']).to eq('123')
  end
end
