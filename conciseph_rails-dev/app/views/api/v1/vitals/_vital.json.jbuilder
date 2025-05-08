# frozen_string_literal: true

json.extract! vital, :id, :vital_type, :user_id, :value, :unit
json.vital_date vital.vital_date.strftime('%d/%m/%Y %H:%M:%S')
json.extract! vital,  :type1, :type2, :type3 if vital.vital_type == 'Blood Sugar Lab'
