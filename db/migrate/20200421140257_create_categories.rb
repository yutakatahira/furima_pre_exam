class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    # ancestryを使って木構造にする。
    create_table :categories do |t|
      t.string :name, null: false
      t.string :ancestry
      t.timestamps
    end
  end
end
