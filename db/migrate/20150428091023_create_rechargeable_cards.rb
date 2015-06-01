class CreateRechargeableCards < ActiveRecord::Migration
  def change
    create_table :rechargeable_cards do |t|
      t.string    :uuid
      t.integer   :user_id
      t.integer   :status,:default=>0
      t.float     :golds,:default=>0
      t.integer   :card_type,:default=>0
      t.timestamps
    end
  end
end
