class Tag < ApplicationRecord
  TAGS=["feed", "feed-fetch-error", "playback", "user-premium", "download"].freeze
  BASE_URL="https://playerassist.freshdesk.com/a/tickets/filters/search?orderBy=created_at&orderType=desc&q[]=created%3A%22last_month%22&q[]=tags%3A%5B%22tagtobereplaced%22%5D&ref=all_tickets"
end
