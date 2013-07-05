# GitHub issues to OmniFocus

This is a little app that runs on Heroku and forwads assigned issues to the
[OmniFocus Mail Drop service](http://www.omnigroup.com/support/omnifocus-mail-drop)

## Config

Folling env vars are needed

`GITHUB_USER` - Get this with

    curl -k -s -u <username> -d '{ "scopes": [ "repo" ], "note": "gh2focus"}'\
    -X POST https://api.github.com/authorizations

`GITHUB_TOKEN` - Token from above
`MAILDROP_ADDRESS` - Address for the omni sync service maildrop
`FROM_ADDRESS` - A from address for the emails it sends

For local/dev:

`DATABASE_URL` - URL to a database
`SENDGRID_USERNAME`
`SENDGRID_PASSWORD`

## Setting up on Heroku

This should do it

    heroku create <appname>
    heroku addons:add sendgrid:starter
    heroku addons:add heroku-postgresql:dev
    heroku addons:add scheduler:standard
    # Populate these of course
    heroku config:add GITHUB_USER= GITHUB_TOKEN= MAILDROP_ADDRESS= FROM_ADDRESS=
    git push heroku master
    heroku addons:open scheduler
    # Set schedule for process `issues2mail` as desired
