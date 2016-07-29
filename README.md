# README

## Run the app locally

The steps to getting the app running locally.

- Clone the repo
- Use Ruby version 2.3.x (if you're not using [rvm](https://rvm.io/), try it)
- install bundler `$ gem install bundler`

Install gem dependencies and javascript inside the folder
- `$ bundle update`
- `$ bundle install`
- `$ npm install`

Set up the database
- Install postgres if you don't already have it.
- Make sure you have access to the heroku staging app to copy some data
- Copy the data from staging into your local db
- `$ heroku pg:pull HEROKU_POSTGRESQL_SILVER roof-api_development --app staging-1roof`

Run the app
- install foreman `$ gem install foreman`
- run the server `$ foreman start -f Procfile.dev`


## Troubleshooting

### OSX

Use ruby 2.3.x don't use 2.2.x. Life will be much easier.
