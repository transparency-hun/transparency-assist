class AddLastFetchedAtToDataTable < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :last_fetched_at, :datetime
  end
end
