class FediAccount < ApplicationRecord
  belongs_to :user
  validates :username, :domain, :user, presence: true
  validates :username, uniqueness: true

  # pagination items per_page
  self.per_page = 10

  def authorized?
    !token.empty?
  end

  def handle
    unless !username || !domain
      [username, domain].join '@'
    else
      ''
    end
  end

  def handle=(input)
    split = input.split '@', 2
    self.username = split.first
    self.domain = split.last
  end

  def self.authorize
    @new_app_response = HTTParty.post("https://#{@fedi_account.domain}/api/v1/apps",
      body: {
        "client_name": "felicitate bot interface",
        "website": "bots.neko.bar",
        "redirect_uris": "urn:ietf:wg:oauth:2.0:oob",
        "scopes": "read write follow push"
      }
    )
    
    false if @new_app_response.code != 200

    @token_response = HTTParty.post("https://#{@fedi_account.domain}/oauth/token",
      body: {
        
      }
    )
  end
end
