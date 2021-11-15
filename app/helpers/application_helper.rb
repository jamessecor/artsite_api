module ApplicationHelper

  def encode_token(payload)
    JWT.encode(payload, ENV["API_SECRET"])
  end

  def verify_jwt(token)
    verified_admin = false

    decoded_token = JWT.decode(token, ENV.fetch("API_SECRET") {""})
    if User.admin.find_by(id: decoded_token.first["user_id"]).present?
      verified_admin = true
    end
    verified_admin
  end

end
