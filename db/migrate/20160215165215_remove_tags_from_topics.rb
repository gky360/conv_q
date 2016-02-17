class RemoveTagsFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :tags, :string
  end
end
