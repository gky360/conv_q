class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :topic_id, null: false
      t.integer :user_id, null: false
      t.integer :reason_flag, null: false, default: 0
      t.text :detail

      t.timestamps null: false
    end
    add_index :reports, [:topic_id, :user_id], unique: true
  end
end
