class CreateFediAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :fedi_accounts do |t|
      t.string :name, null: false
      t.string :access_token
      t.datetime :authorized_at
      t.belongs_to :user
      t.belongs_to :domain
      t.timestamps
      t.index [:name, :user_id, :domain_id], unique: true
    end
  end
end
