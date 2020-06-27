class RenameDeliveryAgencyColumnToItems < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :delivery_agency, :prefecture_id
  end
end
