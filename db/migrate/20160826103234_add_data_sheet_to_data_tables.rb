class AddDataSheetToDataTables < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :data_tables, :data_sheet
  end

  def self.down
    remove_attachment :data_tables, :data_sheet
  end
end
