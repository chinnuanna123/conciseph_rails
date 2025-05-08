# frozen_string_literal: true

json.data do
    json.results do
        json.partial! "medication", medication: @medication
    end
end
json.status 'success'