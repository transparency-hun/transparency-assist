class AddLabelsToDataTable < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :recent, :boolean, null: false, default: false
    add_column :data_tables, :highlighted, :boolean, null: false, default: false
  end
end
