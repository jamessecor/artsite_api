module Api
  class UsersController < ApplicationController
    # TODO: fix this if necessary, or remove
    # def options
    #   render json: {}, status: :unprocessable_entity
    # end

    def jwt_token
      user = User.find_by(id: params[:id])
      if user.present?
        payload = {user_id: user.id}
        token = encode_token(payload)
        render json: {user: user, jwt: token, status: :ok}
      else
        render json: {errors: user.errors.full_messages, status: :unprocessable_entity}
      end
    end

    private

    def user_params
      params.permit(:username, :password)
    end
  end
end
