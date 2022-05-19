class AuthorizationTokenService
  HMAC_SECRET = 'my$ecretK3y'
  ALGO_TYPE = 'HS256'

  def self.encode(user_id)
    payload = { user_id: user_id }
    return JWT.encode payload, HMAC_SECRET, ALGO_TYPE
  end

  def self.decode(token)
    return JWT.decode token, HMAC_SECRET, true, { algorithm: ALGO_TYPE }
  end
end
