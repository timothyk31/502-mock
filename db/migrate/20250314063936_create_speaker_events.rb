class CreateSpeakerEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :speaker_events do |t|
      t.string :ytLink
      t.references :event, null: false, foreign_key: true
      t.references :speaker, null: false, foreign_key: true

      t.timestamps
    end
  end
end
