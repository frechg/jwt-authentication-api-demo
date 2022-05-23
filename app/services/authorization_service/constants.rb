module AuthorizationService
  module Constants
    HMAC_SECRET = Rails.application.credentials.secret_key_base
    ALGO_TYPE = 'HS256'
  end
end
