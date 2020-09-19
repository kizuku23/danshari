class CreatePostComments < ActiveRecord::Migration[5.2]
  def change
    create_table :post_comments do |t|
      t.references :user, type: :bigint, foreign_key: true
      t.references :post, type: :bigint, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
