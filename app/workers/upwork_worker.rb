require 'uri'
require 'net/http'

class UpworkWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'upwork'

  def perform(hook_url, title, message, action)
    payload = Hash.new
    payload["replace_original"] = true
    if action == "suspend"
      payload["text"] = UpworkService.new(title, message).suspend
    else
      payload["text"] = UpworkService.new(title, message).resume
    end
    puts payload.inspect
    # send_response(payload, hook_url)
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