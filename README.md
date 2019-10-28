# About the app

This is a standard Ruby on Rails application. It contains the webservice, which consumes the freshdesk API against get the results according to tags. This application uses background jobs to get all the data from the freshdesk and stores it. It refreshes the data every hour. This application responds against the Slack's slash command `fdtriage` which responds with all the stats accordingly.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
