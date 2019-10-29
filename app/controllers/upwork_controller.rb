class UpworkController < ApplicationController
  def suspend
    #TODO call workers
    render status: 200, json: {"text": "Sending Request to Upwork. Please Wait....", "replace_original": "true"}
  end

  def restart
    #TODO call workers here
    render status: 200, json: {"text": "Sending Request to Upwork. Please Wait....", "replace_original": "true"}
  end
end
