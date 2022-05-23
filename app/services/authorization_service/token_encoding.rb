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
    rescue JWT::EncodeError => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, token: token})
    end
  end
end
