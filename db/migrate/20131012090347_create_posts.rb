class CreatePosts < ActiveRecord::Migration
  def up
    create_table :listings do |t|
      t.string :title
      t.string :description
      t.string :price
      t.integer :user_id
      t.string :secret_key
      t.timestamp
    end
  end

  def down
    drop_table :listings
  end
end
