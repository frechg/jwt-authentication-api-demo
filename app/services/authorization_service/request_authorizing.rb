module AuthorizationService
  module RequestAuthorizing
    include ActionController::HttpAuthentication::Token

    def require_authorization
      unless request_is_authorized?
        unauthorized_request
      end
    end

    private

    def request_is_authorized?
      current_user
    end

    def unauthorized_request
      head :unauthorized
    end

    def current_user
      @current_user ||= user_from_request
    end

    def user_from_request
      id = user_id_from_auth_token

      if id
        User.find(id)
      else
        nil
      end

    rescue ActiveRecord::RecordNotFound
      unauthorized_request
    end

    def user_id_from_auth_token
      payload = AuthorizationService::TokenDecoding.new({decoding_params:
        { token: token_from_request }
      }).call

      if payload && payload.success?
        payload.payload[0]['user_id']
      else
        false
      end
    end

    def token_from_request
      token_and_options(request).first
    end
  end
end
