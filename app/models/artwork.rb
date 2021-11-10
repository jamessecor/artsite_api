class Artwork < ApplicationRecord
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize: "100x100"
  end

  belongs_to :show, optional: true

  validates_presence_of :title, :medium, :price, :year

  scope :order_by_artist, -> { joins(:artist).order("#{Artist.quoted_table_name}.first_name, #{Artist.quoted_table_name}.last_name") }

  def as_json(options = {})
    hash = super(options)
    hash["image"] = "#{ENV.fetch("HOST", "")}#{Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)}" if image.present?
    hash
  end

  def display_price
    options = price.to_f % 1 == 0 ? { precision: 0, raise: true } : { raise: true }
    begin
      number_to_currency(price, options)
    rescue
      display_line_breaks(price)
    end
  end

  def display_label
    "#{artist.full_name}&nbsp;&nbsp;&nbsp;&nbsp;#{year}<br/><strong>#{display_line_breaks title}</strong><br/>#{display_line_breaks medium}<br/>#{display_price}".gsub("\"", "&quot;").html_safe
  end
end
