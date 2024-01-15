class Api::V0::SessionsController < ApplicationController
  def create
    @user = User.authenticate(user_params[:email], user_params[:password])

    if !@user.nil?
      render json: UsersSerializer.new(@user).to_json, status: :ok
    else
      raise Mongoid::Errors::DocumentNotFound.new(User, {email: user_params[:email]}, "Bad password")
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
