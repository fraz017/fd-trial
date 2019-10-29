class UpworkController < ApplicationController
  def suspend
    #TODO call workers
    UpworkWorker.perform_in(2.seconds, params["response_url"], params["title"], params["message"], "suspend")
    render status: 200, json: {"text": "Sending Request to Upwork. Please Wait....", "replace_original": "true"}
  end

  def restart
    #TODO call workers here
    UpworkWorker.perform_in(2.seconds, params["response_url"], params["title"], params["message"], "resume")
    render status: 200, json: {"text": "Sending Request to Upwork. Please Wait....", "replace_original": "true"}
  end
end
