class AddUploaderEmailToDataTable < ActiveRecord::Migration[5.0]
  def change
    add_column :data_tables, :uploader_email, :string
  end
end
