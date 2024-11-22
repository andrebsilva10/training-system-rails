class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false

      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.string :confirmation_code, :string
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end
    add_index :users, :email_address, unique: true
    add_index :users, :confirmation_code, unique: true
  end
end
