class AddChangesetHeadersToDataTable < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :changeset_headers, :hstore, array: true, default: []
  end
end
