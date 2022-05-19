class AuthorizationTokenService
  HMAC_SECRET = Rails.application.credentials.secret_key_base
  ALGO_TYPE = 'HS256'

  def self.encode(payload)
    return JWT.encode payload, HMAC_SECRET, ALGO_TYPE
  end

  def self.decode(token)
    JWT.decode token, HMAC_SECRET, true, { algorithm: ALGO_TYPE }
  end
end
