json.extract! overseer, :id, :name, :email, :password_digest, :role, :created_at, :updated_at
json.url overseer_url(overseer, format: :json)
