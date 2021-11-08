class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.text :description
      t.float :cost
      t.datetime :incurred_at
      t.timestamps
    end
  end
end
