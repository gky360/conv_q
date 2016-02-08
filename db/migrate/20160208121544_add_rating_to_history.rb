class AddRatingToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :rating, :integer, null: false, default: 0
    add_index :histories, [:topic_id, :user_id], unique: true
  end
end
