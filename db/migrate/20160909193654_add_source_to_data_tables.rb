class AddSourceToDataTables < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :source, :string
  end
end
