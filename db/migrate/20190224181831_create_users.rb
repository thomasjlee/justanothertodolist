class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid,      null: false
      t.index  :uid,      unique: true
      t.string :username, null: false
      t.string :token,    null: false
      t.string :secret,   null: false

      t.timestamps
    end
  end
end
