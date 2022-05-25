class ApplicationController < ActionController::API
  include AuthorizationService::RequestAuthorizing

  before_action :require_authorization

end
