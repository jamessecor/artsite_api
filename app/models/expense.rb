class Expense < ApplicationRecord
  validates_presence_of :cost, :date

  has_one_attached :pdf
end
