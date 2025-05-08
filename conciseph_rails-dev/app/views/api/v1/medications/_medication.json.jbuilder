medication_timings = medication.medication_timings
json.extract! medication, :id, :mobile_app_uuid, :name,  :dosage_qty, :dosage_count, :dosage_days, :medication_timing_count

json.start_date medication.start_date.strftime('%d/%m/%Y %H:%M:%S')
json.end_date medication.end_date.strftime('%d/%m/%Y %H:%M:%S')
json.medication_type medication.medication_type_before_type_cast
json.dosage_count_cycle_name medication.dosage_count_cycle_name_before_type_cast
json.dosage_cycle_name medication.dosage_cycle_name_before_type_cast

json.medication_timings_attributes medication_timings do |medication_timing|
  json.extract! medication_timing, :id, :mobile_app_uuid,:qty
  json.scheduled_time medication_timing.scheduled_time&.strftime('%d/%m/%Y %H:%M:%S')
  json.taken_at medication_timing.taken_at&.strftime('%d/%m/%Y %H:%M:%S')
end
json.status 'success'

