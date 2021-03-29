class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable
  has_many :fedi_accounts

  # pagination items per_page
  self.per_page = 10 
end
