# frozen_string_literal: true

json.data do
  json.results @users do |user|
    json.partial! 'member_compliance', user: user
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @users
end

json.status 'success'
