class AddConfirmedToDataSource < ActiveRecord::Migration[5.0]
  def change
    add_column :data_sources, :confirmed, :boolean, default: false, null: false
  end
end
