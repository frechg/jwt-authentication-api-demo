class AuthenticationController < ApplicationController
  rescue_from  ActionController::ParameterMissing, with: :params_missing

  def create
    p user_params.inspect

    render json: {token: '123'}, status: :created
  end

  private

  def user_params
   params.require(:user).require([:username, :password])
   params.require(:user).permit(:username, :password)
  end

  def params_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
