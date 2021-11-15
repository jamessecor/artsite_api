module Api
  class ArtworksController < ApplicationController
    before_action :verify_token, only: [:create, :update]

    # Stops processing unless we have a token and it can be verified to be an admin user
    def verify_token
      unless params["token"].present? && verify_jwt(params["token"])
        render json: {message: "Cannot verify login"}, status: :unauthorized
      end
    end

    def index
      # TODO: Deal with pagination
      if params[:search].present?
        term = params[:search]
        artworks = Artwork.all
        artworks = artworks.where("year = ? or price = ?", term, term) if term.is_a? Integer
        artworks = artworks.where("title like ? or medium like ?", "%#{term}%", "%#{term}%") if term.is_a? String
      else
        artworks = Artwork.order(:created_at).limit(15)
        artworks = artworks.where(year: params[:year_filter]) if params[:year_filter].present?
      end
      artworks = artworks.limit(params[:limit]) if params[:limit].present?
      render :json => artworks.map(&:as_json)
    end

    def create
      serialization_options = {admin: true}
      artwork = Artwork.create(permitted_params)
      if artwork.persisted?
        artwork.image.attach(params[:image]) if params[:image].present?
        response = { :status => "ok", :insertNewForm => true, :artwork => artwork.to_json(serialization_options), :message => "Successfully created #{params[:title]}!" }
      else
        response = { :status => "failure", :message => "Unable to create artwork." }
      end
      respond_to do |format|
        format.json  { render :json => response }
      end
    end

    def update
      serialization_options = {admin: true}
      artwork = Artwork.find(params[:id])
      artwork.update(permitted_params)
      artwork.image.attach(params[:image]) if params[:image].present?
      respond_to do |format|
        response = { :status => "ok", :artwork => artwork.to_json(serialization_options), :message => "Successfully updated #{params[:title]}!" }
        format.json  { render :json => response }
      end
    end

    private

    def permitted_params
      params.permit(%w[id title year medium price])
      # params.require(:artwork).permit(%w[id title year medium price])
    end
  end
end
