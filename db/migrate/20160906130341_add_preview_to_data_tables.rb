class AddPreviewToDataTables < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :preview, :string, array: true, default: []
  end
end
