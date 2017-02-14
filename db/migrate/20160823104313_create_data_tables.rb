class CreateDataTables < ActiveRecord::Migration[5.0]
  def change
    create_table :data_tables do |t|
      t.belongs_to :admin, index: true, foreign_key: { on_delete: :nullify }
      t.belongs_to :category, null: false, index: true, foreign_key: true
      t.string :title, null: false
      t.text :description, default: ''
      t.boolean :official, default: false
      t.boolean :confirmed, index: true, default: false
      t.timestamps
    end
  end
end
