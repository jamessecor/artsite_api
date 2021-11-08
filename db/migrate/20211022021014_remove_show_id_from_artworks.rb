class RemoveShowIdFromArtworks < ActiveRecord::Migration[6.1]
  def change
    remove_column :artworks, :show_id
  end
end
