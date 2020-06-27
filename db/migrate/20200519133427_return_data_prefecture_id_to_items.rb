class ReturnDataPrefectureIdToItems < ActiveRecord::Migration[5.2]
  def change
    change_column :items, :prefecture_id, :integer
  end
end
