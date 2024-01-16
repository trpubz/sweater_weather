class Api::V0::SessionsController < ApplicationController
  def create
    @user = User.authenticate(user_params[:email], user_params[:password])

    render json: UsersSerializer.new(@user).to_json, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
