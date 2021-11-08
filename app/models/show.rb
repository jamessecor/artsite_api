class Show < ApplicationRecord
  has_many :artworks

  validates_presence_of :name

  def self.current
    self.where(current: true).first
  end

  def self.show_types
    %w[solo group]
  end

end
