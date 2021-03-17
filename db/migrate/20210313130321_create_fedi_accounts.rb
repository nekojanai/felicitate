class CreateFediAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :fedi_accounts do |t|
      t.string :username, unique: true, null: false
      t.string :domain, null: false
      t.string :token
      t.belongs_to :user
      t.timestamps
    end
  end
end
