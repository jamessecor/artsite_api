class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate(auth_options)
    if resource.present? && resource.admin?
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      render json: {errors: "invalid login", status: :unauthorized}, status: :ok
    end
  end
end