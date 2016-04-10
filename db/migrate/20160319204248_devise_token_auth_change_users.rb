class DeviseTokenAuthChangeUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, null: false, default: "email"
    add_column :users, :uid, :string, null: false, default: ""
    add_column :users, :tokens, :text

    User.find_each do |user|
      user.update_columns(uid: user.email, tokens: "{}")
    end

    add_index :users, [:uid, :provider], unique: true
  end
end
