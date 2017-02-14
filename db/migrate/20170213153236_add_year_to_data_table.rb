class AddYearToDataTable < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :year, :integer
  end
end
