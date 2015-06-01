class CreateAssetLogos < ActiveRecord::Migration
  def change
    create_table :asset_logos do |t|
      t.string   "filename"
      t.string   "content_type"
      t.string   "resource_type", :limit => 50
      t.string   "avatar"
      t.integer  "resource_id"
      t.integer  "size"
      t.integer  "width"
      t.integer  "height"
      t.integer  "parent_id"
      t.string   "thumbnail"
      t.string   "alt"
      t.timestamps
    end
  end
end