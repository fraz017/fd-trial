require 'uri'
require 'net/http'

class FreshdeskWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'freshdesk' # job will be discarded if it fails

  def perform
    Tag::TAGS.each do |tag|
      page = 1

      count = 0
      api_path = "api/v2/search/tickets/?page=#{page}&query=%22tag:%27feed%27%20AND%20status:2%22"

      tickets = getTickets(api_path)
      count = count + tickets["results"].count

      if tickets["total"] > 1
        2.upto(tickets["total"]).each do |page|
          page = page + 1
          api_path = "api/v2/search/tickets/?page=#{page}&query=%22tag:%27feed%27%20AND%20status:2%22"
          tickets = getTickets(api_path)
          count = count + tickets["results"].count
        end
      end
      
      t = Tag.find_or_create_by(name: tag)
      t.count = count
      t.url = Tag::BASE_URL.gsub("tagtobereplaced", tag)
      t.save
    end
  end

  def getTickets(api_path)
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
end