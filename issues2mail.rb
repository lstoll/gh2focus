require 'bundler'
require 'pp'

Bundler.require
Dotenv.load

## Setup

DB = Sequel.connect(ENV['DATABASE_URL'])
DB.create_table?(:processed) {String :issue}
# Ignore errors sucks, but no 'create unless'
DB.add_index :processed, :issue, :ignore_errors => true

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

issue = GH.issues.first

GH.issues.each do |issue|
  issue_id = "#{issue[:repository][:name]}/#{issue[:number]}"
  DB[:processed].where('issue = ?', issue_id).count
  unless DB[:processed].where('issue = ?', issue_id).count > 0
    issue_title = issue[:title]
    issue_body = issue[:body]
    puts "DO THE THING"
    DB[:processed].insert(:issue => issue_id)
  end
end