class FediAccount < ApplicationRecord
  belongs_to :user
  validates :username, :domain, :user, presence: true
  validates :username, uniqueness: true

  # pagination items per_page
  self.per_page = 10

  def authorized?
    !token.nil?
  end

  def handle
    unless !username || !domain
      [username, domain].join '@'
    else
      ''
    end
  end

  def handle=(input)
    if (input =~ /@/) == 0
      split = input[1..].split '@', 2
    elsif (input =~ /@/) != nil
      split = input.split '@', 2
    else
      raise "invalid fedi handle, please use this format: @example@domain.tld"
    end
    self.username = split.first
    self.domain = split.last
  end

  def authorize(password)
    new_app_response = HTTParty.post("https://#{domain}/api/v1/apps",
      body: {
        "client_name": "felicitate bot interface",
        "website": "bots.neko.bar",
        "redirect_uris": "urn:ietf:wg:oauth:2.0:oob",
        "scopes": "read write follow push"
      }
    )
    
    return false if new_app_response.code != 200
    
    new_app_response_body = JSON.parse new_app_response.body, symbolize_names: true

    token_response = HTTParty.post("https://#{domain}/oauth/token",
      body: {
        "username": "#{username}@#{domain}",
        "password": password,
        "grant_type": "password",
        "client_id": new_app_response_body[:client_id],
        "client_secret": new_app_response_body[:client_secret]
      }
    )

    pp token_response
  end
end
