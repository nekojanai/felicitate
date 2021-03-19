json.extract! fedi_account, :username, :domain, :token, :id, :created_at, :updated_at
json.url fedi_account_url(fedi_account, format: :json)
