class FediAccount < ApplicationRecord
  belongs_to :user
  validates :username, :domain, :user, presence: true

  def authorized?
    !token.empty?
  end

end
