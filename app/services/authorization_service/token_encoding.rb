module AuthorizationService
  class TokenEncoding
    include Constants

    def initialize(params)
      @payload = params[:encoding_params]
    end

    def call
      token = JWT.encode(
        @payload,
        HMAC_SECRET,
        ALGO_TYPE
      )
    end
  end
end
