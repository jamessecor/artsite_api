class AddColumnsToArtwork < ActiveRecord::Migration[6.1]
  def change
    add_column :artworks, :sale_price, :float
    add_column :artworks, :tax_paid, :boolean, default: false
  end
end
