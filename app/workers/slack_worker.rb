require 'uri'
require 'net/http'

class SlackWorker
  TAGS = ["team", "takedown", "premium", "account", "crash", "battery", "feed", "playback", "subscription", "download", "playlist",
    "search", "web", "ios", "localization", "content", "ui", "feature-request","unclassified", "spam", "feature-request", "user-premium"].freeze
  
  URL_HASH = Hash.new
  TICKETS_COUNT_HASH = Hash.new  
  TAGS.each do |tag|
    if tag == "unclassified"
      URL_HASH[tag] = "https://playerassist.freshdesk.com/a/tickets/filters/search?orderBy=created_at&orderType=desc&q[]=created%3A%22last_month%22&q[]=status%3A%5B2%5D&ref=all_tickets"
    else
      URL_HASH[tag] = "https://playerassist.freshdesk.com/a/tickets/filters/search?orderBy=created_at&orderType=desc&q[]=created%3A%22last_month%22&q[]=status%3A%5B2%5D&q[]=tags%3A%5B%22#{tag}%22%5D&ref=all_tickets"
    end
    TICKETS_COUNT_HASH[tag] = 0
  end  

  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'slack'

  def perform(hook_url)
    page = 1
    api_path = "api/v2/search/tickets/?page=#{page}&query=%22status:2%22"
    tickets = get_tickets(api_path)
    set_counts(tickets)    
    
    total_pages = (tickets["total"]/30)+1
    if total_pages > 1
      2.upto(total_pages).each do |i|
        page+=1
        api_path = "api/v2/search/tickets/?page=#{page}&query=%22status:2%22"
        tickets = getTickets(api_path)
        set_counts(tickets)
      end
    end

    text = Array.new
    payload = Hash.new
    total = 0
    TICKETS_COUNT_HASH.each do |k, v|
      text.push("`#{v}` #{k} <#{URL_HASH[k]}|#{k} tickets>") if v > 0
      total += v      
    end
    text.push("----")
    text.push("`#{total}` total")

    payload["replace_original"] = true
    payload["text"] = text.join("\n")

    send_response(payload, hook_url)
  end

  def set_counts(tickets)
    tickets["results"].each do |ticket|
      if ticket["tags"].length == 0
        TICKETS_COUNT_HASH["unclassified"] += 1
      else
        ticket["tags"].each do |tag|
          if TICKETS_COUNT_HASH.has_key?(tag)
            TICKETS_COUNT_HASH[tag] += 1
          end  
        end
      end
    end
  end

  def get_tickets(api_path)
    fd_domain = ENV['FD_DOMAIN']

    # It could be either your user name or api_key.
    user_name_or_api_key = ENV['USERNAME']

    # If you have given api_key, then it should be x. If you have given user name, it should be password
    password_or_x = ENV['PASSWORD']
    api_url  = "#{fd_domain}/#{api_path}"

    url = URI(api_url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(user_name_or_api_key, password_or_x)
    request["authorization"] = auth
    
    response = http.request(request)
    return JSON.parse(response.body)
  end

  def send_response(payload, hook_url)
    url = URI(hook_url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request.body = payload.to_json

    response = http.request(request)
  end
end