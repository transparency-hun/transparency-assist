class AddTimestampsToDataSource < ActiveRecord::Migration[5.0]
  def self.up
    add_column :data_sources, :created_at, :datetime, null: false, default: Time.current
    add_column :data_sources, :updated_at, :datetime, null: false, default: Time.current

    DataSource.reset_column_information

    change_column_default(:data_sources, :created_at, nil)
    change_column_default(:data_sources, :updated_at, nil)
  end

  def self.down
    remove_column :data_sources, :created_at
    remove_column :data_sources, :updated_at
  end
end
