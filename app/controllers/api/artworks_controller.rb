module Api

  class ArtworksController < ApplicationController
    # def image
    #   artwork = Artwork.find_by(id: params[:id])
    #   result = {}
    #   if artwork&.image&.attached?
    #     result["src"] = rails_blob_url(artwork.image)
    #     result["status"] = :ok
    #     render json: result
    #   else
    #     head :not_found
    #   end
    # end

    def index
      if params[:search].present?
        term = params[:search]
        artworks = Artwork.where("title like ? or medium like ? or year = ? or price = ?", "%#{term}%", "%#{term}%", term, term)
      else
        artworks_query = Artwork.order(:created_at)
        artworks_query = artworks_query.where(year: params[:year_filter]) if params[:year_filter].present?
        artworks = artworks_query
      end
      render :json => artworks.map(&:as_json)
    end

    def create
      serialization_options = {admin: current_user&.admin?}
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
      serialization_options = {admin: current_user&.admin?}
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
