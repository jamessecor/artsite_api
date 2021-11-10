module Api
  class ContactsController < ApplicationController
    def new_contact
      contact = Contact.create(
        firstname: params[:firstname],
        lastname: params[:lastname],
        message: params[:message],
        email: params[:email]
      )
      if contact.persisted?
        response = { status: :ok, message: "Thank you for your submission" }
      elsif contact.errors.any?
        response = { status: :failure, errors: contact.errors.objects.map(&:attribute).uniq }
      else
        response = { status: :invalid }
      end

      respond_to do |format|
        format.json { render :json => response }
      end
    end
  end
end
