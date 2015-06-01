class CreateUserPurses < ActiveRecord::Migration
  def change
    create_table :user_purses do |t|
      t.float :golds, :default => 1
      t.integer :user_id
      t.string  :taobao_login
      t.timestamps
    end
  end
end
