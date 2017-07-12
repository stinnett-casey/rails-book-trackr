class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :sku
      t.string :title
      t.string :category
      t.string :author

      t.timestamps
    end
  end
end
