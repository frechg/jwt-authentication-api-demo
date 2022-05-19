class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  before_action :require_authorization

  private

  def require_authorization
    request_authorizing
  end

  def request_authorizing
    token, _options = token_and_options(request)
    payload = AuthorizationTokenService.decode(token)
    user_id = payload[0]['user_id']
    @current_user = User.find(user_id)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    head :unauthorized
  end

  def current_user
    @current_user ||= nil
  end
end
