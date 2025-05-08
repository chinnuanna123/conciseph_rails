# frozen_string_literal: true

json.data do
  json.results do
    json.action_plans @counters_hash[:action_plans_hash].keys do |section_key|
      json.name section_key
      json.count @counters_hash[:action_plans_hash][section_key].presence || 0
    end
    json.announcement Announcement.sections.values do |index|
        section_key = Announcement.sections.key(index)
        json.name section_key
        json.count  @counters_hash[:announcement_count_hash][index].presence || 0

    end
    json.feedback MemberFeedback.sections.values do |index|
        section_key = MemberFeedback.sections.key(index)
        json.name section_key
        json.count @counters_hash[:feedback_count_hash][index].presence || 0
    end
  end
end
