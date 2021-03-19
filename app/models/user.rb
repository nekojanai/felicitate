class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable
  has_many :fedi_accounts
end
