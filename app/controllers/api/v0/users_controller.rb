class Api::V0::UsersController < ApplicationController
  # before_action :set_user, only: %i[show update destroy]

  def create
    @user = User.new(user_params)

    render json: UsersSerializer.new(@user).to_json, status: :created, location: @user if @user.save!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.permit(:email, :password, :password_confirmation, :api_key)
  end
end
