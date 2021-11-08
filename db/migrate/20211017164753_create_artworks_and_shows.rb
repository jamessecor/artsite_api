class CreateArtworksAndShows < ActiveRecord::Migration[6.1]
  def change
    create_table :artworks do |t|
      t.integer :show_id
      t.string :title
      t.string :medium
      t.integer :year
      t.string :grouping
      t.integer :price
      t.integer :buyer_id
      t.datetime :sale_date
      t.timestamps
    end

    create_table :shows do |t|
      t.string :name
      t.string :location_name
      t.text :description
      t.date :start
      t.date :end
      t.timestamps
    end
  end
end
