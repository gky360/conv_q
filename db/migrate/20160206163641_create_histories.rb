class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :topic_id
      t.integer :user_id
      t.integer :times,   null: false, default: 0

      t.timestamps null: false
    end
  end
end
