class RemoveNotNullConstraintFromDataSource < ActiveRecord::Migration[5.0]
  def change
    change_column_null :data_sources, :name, true
  end
end
