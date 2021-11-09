class Contact < ApplicationRecord
  validates_presence_of :email
  validate :validate_email

  def validate_email
    errors.add(:email, message: "Invalid email") unless email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
