class Api::V0::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    render json: UsersSerializer.new(@user).to_json, status: :created if @user.save!
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
