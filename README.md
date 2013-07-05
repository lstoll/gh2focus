# GitHub issues to OmniFocus

This is a little app that runs on Heroku and forwads assigned issues to the
OmniFocus Mail Drop service

## Config

Folling env vars are needed

`GITHUB_USER`
Get this with

    curl -k -s -u <username> -d '{ "scopes": [ "repo" ], "note": "gh2focus"}'\
    -X POST https://api.github.com/authorizations

`GITHUB_TOKEN`
