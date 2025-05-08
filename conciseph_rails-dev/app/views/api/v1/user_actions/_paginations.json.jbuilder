json.pagination do
    if user_actions.present?
      json.current_page user_actions&.current_page.presence || 0
      json.total_pages user_actions&.total_pages.presence || 0
      json.total_count user_actions&.total_entries.presence || 0
    else
      json.current_page 0
      json.total_pages 0
      json.total_count 0
    end
end