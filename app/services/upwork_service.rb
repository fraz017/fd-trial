class UpworkService
  def initialize(title, message)
    @title = title.downcase
    @message = message
    @slack_response = Hash.new
  end

  def suspend 
    find_engagement
    puts "In suspend"  
    # suspended = false
    # job_reference = ""

    # suspended, job_reference = find_engagement
    # return @slack_response["text"] = "Contract is already suspended" if suspended
    # return @slack_response["text"] = "Unable to find enagement, try another keyword" if job_reference.blank?

    # contracts = Net::Upwork::API::Routers::Hr::Contracts.new(client)
    # params = {
    #   'message' => @message
    # }
    # upwork_response = contracts.suspend_contract(job_reference, params)
    # return @slack_response["text"] = "Successfully suspended the contract" if upwork_response["message"] == "OK"
    # return @slack_response["text"] = "Unable to process request, Please try again later"
  end

  def resume
    find_engagement
    puts "In resume"
    # suspended = true
    # job_reference = ""

    # suspended, job_reference = find_engagement

    # return @slack_response["text"] = "Contract is already resumed" if !suspended
    # return @slack_response["text"] = "Unable to find enagement, try another keyword" if job_reference.blank?

    # contracts = Net::Upwork::API::Routers::Hr::Contracts.new(client)
    # params = {
    #   'message' => @message
    # }
    # upwork_response = contracts.restart_contract(job_reference, params)
    # return @slack_response["text"] = "Successfully resumed the contract" if upwork_response["message"] == "OK"
    # return @slack_response["text"] = "Unable to process request, Please try again later"
  end

  private

  def find_engagement
    puts "In Find engagement"
    #TODO pagination traversal according to response
    # engagements = Net::Upwork::API::Routers::Hr::Engagements.new(client)
    # suspended = false
    # #client needs to be defined
    # engagement_list = engagements.get_list({})
    # engagement_list.each do |engagement|
    #   if engagement["job__title"].downcase.include?(@title)
    #     job_reference = engagement["reference"]
    #     suspended = true if engagement["is_suspended"]
    #     break
    #   end
    # end
    # return suspended, job_reference
  end
end