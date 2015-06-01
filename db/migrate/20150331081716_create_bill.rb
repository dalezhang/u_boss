class CreateBill < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer  :user_id
      t.float    :price
      t.integer  :tp, :default => 0
      t.string   :trade_no
      t.string   :prepayid
      t.boolean  :status, :default => false
      t.string   :note
      t.timestamps
    end
  end
end
