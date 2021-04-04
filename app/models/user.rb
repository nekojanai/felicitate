class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable
  validates :name, exclusion: { in: %w( admin superuser root ) }
  has_many :fedi_accounts, dependent: :destroy

  # pagination items per_page
  self.per_page = 10 
end
