module Api
  class UsersController < ApplicationController
    def jwt_token
      user = User.find_by(id: params[:id])
      if user.present?
        payload = {user_id: user.id, email: user.email}
        token = encode_token(payload)
        render json: {user: user, jwt: token, status: :ok}
      else
        render json: {errors: user.errors.full_messages, status: :unprocessable_entity}
      end
    end

    def auto_login
      if params["token"].present? && verify_jwt(params["token"])
        render json: {message: "You are already logged in", status: :ok}, status: :ok
      else
        render json: {message: "Cannot verify login", status: :unauthorized}, status: :ok
      end
    end

    private

    def user_params
      params.permit(:username, :password)
    end
  end
end
