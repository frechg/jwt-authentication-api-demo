class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  before_action :require_authorization

  private

  def require_authorization
    request_authorizing
  end

  def request_authorizing
    payload = AuthorizationService::TokenDecoding.new({decoding_params:
      { token: token_extracting }
    }).call

    if payload && payload.success?
      @current_user = User.find(payload.payload[0]['user_id'])
    else
      head :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    head :unauthorized
  end

  def token_extracting
    token, options = token_and_options(request)
    return token
  end

  def current_user
    @current_user ||= nil
  end
end
