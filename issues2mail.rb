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

GH.issues.each do |issue|
  issue_id = "#{issue[:repository][:name]}/#{issue[:number]}"
  DB[:processed].where('issue = ?', issue_id).count
  unless DB[:processed].where('issue = ?', issue_id).count > 0
    issue_repo  = issue[:repository]
    issue_title = issue[:title]
    issue_body  = issue[:body]
    issue_url   = issue[:url]
    puts "Sending mail for #{issue_title}"
    Pony.mail(:to => ENV['MAILDROP_ADDRESS'],
              :from => ENV['FROM_ADDRESS'],
              :subject => "[#{issue_repo}] #{issue_title}",
              :body => "#{issue_body}\n\n#{issue_url}")
    DB[:processed].insert(:issue => issue_id)
  end
end
