class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :data_table, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :taggings, [:tag_id, :data_table_id], unique: true
  end
end
