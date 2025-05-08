# frozen_string_literal: true

json.data do
  json.results @visit_types do |visit_type|
    json.extract! visit_type, :name, :code
  end
end
json.status 'success'
