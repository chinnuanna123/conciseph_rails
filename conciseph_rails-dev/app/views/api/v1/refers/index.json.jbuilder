# frozen_string_literal: true

json.data do
  json.results @refers do |refer|
    json.extract! refer, :name, :code, :secrete_code, :payment_required
  end
end

json.status 'success'
