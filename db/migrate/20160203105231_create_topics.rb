class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text   :title , null: false
      t.string :tags
      t.string :source_url

      t.timestamps null: false
    end
  end
end
