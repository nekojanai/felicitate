class Domain < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :fedi_accounts, dependent: :destroy
end
