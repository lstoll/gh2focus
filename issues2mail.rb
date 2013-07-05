require 'bundler'
require 'pp'

Bundler.require
Dotenv.load

## Setup

DB = Sequel.connect(ENV['DATABASE_URL'])
DB.create_table?(:processed) {primary_key :id}

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

GH = Octokit::Client.new(:login => ENV['GITHUB_USER'], :oauth_token => ENV['GITHUB_TOKEN'])

## Do it

pp GH.issues.first

# GH.issues.each do |issue|

# end
