require 'uri'
require 'net/http'

class SlackWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'slack'

  def perform(hook_url)
    text = Array.new
    total = 0
    Tag.where("count > ?", 1).each do |tag|
      text.push("`#{tag.count}` #{tag.name} <#{tag.url}|#{tag.name} tickets>")
      total = total + tag.count
    end
    text.push("----")
    text.push("`#{total}` total")

    payload = Hash.new
    payload["replace_original"] = true
    payload["text"] = text.join("\n")

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