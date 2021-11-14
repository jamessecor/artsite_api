module ApplicationHelper
  def verify_jwt(token)
    verified_admin = false

    decoded_token = JWT.decode(token, ENV.fetch("API_SECRET") {""})
    if User.admin.find_by(id: decoded_token.first["user_id"]).present?
      verified_admin = true
    end
    render json: {decoded_token: decoded_token}, status: :unauthorized unless verified_admin
  end

end
