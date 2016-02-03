class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text   :title , null: false
      t.string :tags
      t.string :source

      t.timestamps null: false
    end
  end
end
