json.pagination do
    if models.present?
      json.current_page models&.current_page.presence || 0
      json.total_pages models&.total_pages.presence || 0
      json.total_count models&.total_entries.presence || 0
    else
      json.current_page 0
      json.total_pages 0
      json.total_count 0
    end
end