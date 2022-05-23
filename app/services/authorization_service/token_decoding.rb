module AuthorizationService
  class TokenDecoding
    include Constants

    def initialize(params)
      @token = params[:decoding_params][:token]
    end

    def call
      payload = JWT.decode(
        @token,
        HMAC_SECRET,
        true,
        { algorithm: ALGO_TYPE }
      )
    rescue JWT::DecodeError => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: payload})
    end
  end
end
