class FdController < ApplicationController
  def recieve
    SlackWorker.perform_in(2.seconds, params["response_url"])
    render status: 200, json: {"text": "Compiling Freshdesk Data. Please Wait....", "response_type": "ephemeral"}
  end
end
