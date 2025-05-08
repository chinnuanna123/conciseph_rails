# frozen_string_literal: true

json.data do
  json.results @allergies do |allergy|
    json.extract! allergy, :name
    json.code allergy.code.to_i
  end
end
json.status 'success'
# json.iv @iv.force_encoding("ISO-8859-1").encode("UTF-8")
# json.salt @salt.force_encoding("ISO-8859-1").encode("UTF-8")
