class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :cors_set_access_control_headers

  def encode_token(payload)
    JWT.encode(payload, ENV["API_SECRET"])
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    # headers['Access-Control-Allow-Origin'] = ENV.fetch("FRONTEND_URL") { "" }
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def after_sign_in_path_for(resource_or_scope)
    jwt_token_api_users_path(id: resource_or_scope.id)
  end
end
