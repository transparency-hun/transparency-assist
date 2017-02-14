class CreateDataSources < ActiveRecord::Migration[5.0]
  def change
    create_table :data_sources do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :data_table_id, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.hstore :changeset_headers, array: true, default: []
      t.jsonb :changeset, default: []
      t.timestamp :last_fetched_at
    end
  end
end
