require 'rails_helper'

RSpec.describe AuthorizationTokenService  do
  context '.call' do
    it 'returns an authorization token' do
      expect(described_class.call).to eq('123')
    end
  end
end
