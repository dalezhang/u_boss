class AudioUseRecord < ActiveRecord::Migration
  def change
    create_table :audio_use_records do |t|
      t.integer :audio_id
      t.integer :status
      t.timestamps
     end
  end
end
