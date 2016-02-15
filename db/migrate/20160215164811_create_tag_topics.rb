class CreateTagTopics < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.integer :tag_id, null: false
      t.integer :topic_id, null: false

      t.timestamps null: false
    end
  end
end
