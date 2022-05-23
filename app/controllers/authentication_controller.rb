class AuthenticationController < ApplicationController
  rescue_from  ActionController::ParameterMissing, with: :params_missing
  skip_before_action :require_authorization, only: :create

  def create
    @user = User.find_by(email: user_params[:email])

    if @user && @user.authenticate(user_params[:password])
      token = AuthorizationService::TokenEncoding.new({encoding_params:
        { user_id: @user.id }
      }).call

      if token && token.success?
        response_data = { token: token.payload, username: @user.username }
        render json: response_data, status: :created
      else
        head :unauthorized
      end
    else
      head :unauthorized
    end
  end

  private

  def user_params
   params.require(:user).require([:email, :password])
   params.require(:user).permit(:email, :password)
  end

  def params_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
