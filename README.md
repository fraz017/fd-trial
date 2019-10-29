# About the app

This is a standard Ruby on Rails application. It contains the webservice, which consumes the freshdesk API against get the results according to tags. This application uses background jobs to get all the data from the freshdesk and stores it. It refreshes the data every hour. This application responds against the Slack's slash command `/fdtriage` which responds with all the stats accordingly.

In order to setup the app on to your local machine please go through https://gorails.com/deploy/ubuntu/18.04. You will also need to install **redis** in order to execute the background jobs.

To run the background jobs **sidekiq** is used.

# Key Notes
* Slack command triggers our action `recieve` defined in `controllers/fd_controller.rb`
* Upon recieving the request from slack our asynchronus task handles the freshdesk processing and responds with the data accordingly. Worker can be found at `app/workers/slack_wroker.rb`
* All the tags are defined in the form of an array in `app/workers/slack_worker.rb`. You can add or remove tags there and all the urls and counts will be adjusted automatically
* All credentials are being handled in the environemnt variables. Create a file `local_env.yml` in config
* Set the following variables
  * USERNAME: 'XXXXXX' (set your frashdesk username)
  * PASSWORD: 'XXXXXX' (set your freshdesk password)
  * FD_DOMAIN: 'XXXXX' (set your freshdesk domain e.g `https://xxxx.freshdesk.com`)