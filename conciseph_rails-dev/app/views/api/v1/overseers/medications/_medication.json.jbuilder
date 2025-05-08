json.member_name medication.user&.name || ''
json.medication_name medication.name || ''
json.status medication.status
json.total_dosage medication.medication_timings.count
json.dosage_completed medication.medication_timings.where(taken_at: nil ).count
json.dosage_remaining medication.medication_timings.where.not(taken_at: nil ).count