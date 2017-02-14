class AddPreviewToDataSource < ActiveRecord::Migration[5.0]
  def change
    add_column :data_sources, :preview, :string, array: true, default: []
    add_column :data_sources, :diff, :jsonb, default: []
  end
end
