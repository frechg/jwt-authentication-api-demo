class UsersController < ApplicationController
  def show
    @user = User.find(user_params)

    if @user == current_user
      data = { email: @user.email, username: @user.username }
      render json: data, status: :ok
    else
      head :unauthorized
    end
  end

  private

  def user_params
    params.require(:id)
  end
end
