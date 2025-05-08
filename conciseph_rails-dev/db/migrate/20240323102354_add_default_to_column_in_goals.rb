class AddDefaultToColumnInGoals < ActiveRecord::Migration[6.0]
  def change
    change_column_default :goals, :goal_type, from: nil, to: 0
    change_column_default :member_feedbacks, :member_feedback_type, from: nil, to: 0
    change_column_default :compliances, :compliance_type, from: nil, to: 0
    change_column_default :health_educations, :health_education_type, from: nil, to: 0
    change_column_default :health_events, :health_event_type, from: nil, to: 0
    change_column_default :announcements, :announcement_type, from: nil, to: 0
  end
end
