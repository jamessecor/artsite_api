module Api
  class ContactsController < ApplicationController
    protect_from_forgery with: :null_session

    def new_contact
      contact = Contact.create(
        firstname: params[:firstname],
        lastname: params[:lastname],
        message: params[:message],
        email: params[:email]
      )
      if contact.persisted?
        response = { status: :ok, message: "Thank you for your submission" }
      else
        response = { status: :failure }
      end

      respond_to do |format|
        format.json { render :json => response }
      end
    end
  end
end
