class FediAccount < ApplicationRecord
  belongs_to :user

  def authorized?
    !token.empty?
  end
end
