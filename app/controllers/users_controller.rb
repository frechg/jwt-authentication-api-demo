class UsersController < ApplicationController
  rescue_from  ActionController::ParameterMissing, with: :params_missing
  skip_before_action :require_authorization, only: :create

  def show
    @user = User.find(params.require(:id))

    if @user == current_user
      data = { email: @user.email, username: @user.username }
      render json: data, status: :ok
    else
      head :unauthorized
    end
  end

  def create
    @user = User.new(new_user_params)

    if @user.save
      token = AuthorizationTokenService::encode({user_id: @user.id})
      data = { username: @user.username, token: token }
      render json: data, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def new_user_params
    params.require(:new_user).require([:username, :email, :password])
    params.require(:new_user).permit(:username, :email, :password)
  end

  def params_missing(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
