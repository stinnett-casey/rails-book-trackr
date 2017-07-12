class CreateUserBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_books do |t|
      t.references :user
      t.references :book
      t.integer :times_read, default: 0
      t.boolean :own_it, default: false
      t.integer :priority
      t.boolean :favorite, default: false

      t.timestamps
    end
  end
end
