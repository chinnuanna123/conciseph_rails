user = member.user
json.extract! member, :name
json.enrollment_status member.user_id.present? ? 'enrolled' : 'not enrolled'
json.enrolled_date format_date_time(user&.created_at) || ''
json.member_last_action_date format_date_time(user&.last_seen_at) || ''