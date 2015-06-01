class CreatePostProducts < ActiveRecord::Migration
  def change
    create_table :post_products do |t|

      t.timestamps
    end
  end
end
