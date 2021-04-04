class FediAccount < ApplicationRecord
  belongs_to :user
  belongs_to :domain
  validates :name, :domain, :user, presence: true
  validates :name, uniqueness: { scope: [:user, :domain] }
  validate :handle_format

  # pagination items per_page
  self.per_page = 10

  def authorized?
    !access_token.nil?
  end

  def handle
    if name && domain&.name then "@#{[name, domain.name].join('@')}" else '' end
  end

  def handle=(input)
    unless match = /@?([-.\w]+)@{1}([-.\w]+)/.match(input)&.captures then return end
    self.name = match[0]
    self.domain = Domain.find_or_create_by!(name: match[1])
  end

  def authorize_and_save!(password)

    raise FediAccountError.new self unless self.valid?
    
    new_app_response = HTTParty.post("https://#{self.domain&.name}/api/v1/apps",
      body: {
        "client_name": "felicitate bot interface",
        "website": "bots.neko.bar",
        "redirect_uris": "urn:ietf:wg:oauth:2.0:oob",
        "scopes": "read write follow push"
      }
    )
    
    raise FediAccountError.new self, "Unable to perform oauth app registration" if new_app_response&.code != 200 || new_app_response&.headers&.content_type != 'application/json' 
    
    new_app_response_body = JSON.parse new_app_response.body, symbolize_names: true

    token_response = HTTParty.post("https://#{self.domain&.name}/oauth/token",
      body: {
        "username": "#{self.name}@#{self.domain&.name}",
        "password": password,
        "grant_type": "password",
        "client_id": new_app_response_body[:client_id],
        "client_secret": new_app_response_body[:client_secret]
      }
    )
    
    raise FediAccountError.new self, "Unable to obtain oauth access_token" if token_response.code != 200 || new_app_response&.headers&.content_type != 'application/json'

    token_response_body = JSON.parse token_response.body, symbolize_names: true

    self.access_token = token_response_body[:access_token]
    self.authorized_at = Time.now
    self if self.save!

  rescue SocketError => error
    Rails.logger.error error.message
    raise FediAccountError.new self, "Unable to perform oauth auth"
  end

  private def handle_format
    errors.add :handle, 'invalid format, please use: @username@domain.tld' unless (/@?([-.\w]+)@{1}([-.\w]+)/.match handle)
  end

  private class FediAccountError < StandardError
    def initialize(record, message = 'Invalid handle')
      record.errors.add :handle, message
      super(record)
    end
  end

end