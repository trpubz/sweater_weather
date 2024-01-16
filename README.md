# Sweater Weather

You are a back-end developer working on a team that is building an application to plan road trips. This app will allow users to see the current weather as well as the forecasted weather at the destination.

Your team is working in a service-oriented architecture. The front-end will communicate with your back-end through an API. Your job is to expose that API that satisfies the front-end team’s requirements.

* Ruby version 

`3.2.2`

* Configuration

`rails new <NAME> --api --skip-active-record  --skip-test --skip-system-test --skip-bundle` <br>
Mongodb does not use ActiveRecord, and ActiveStorage can cause issues; ensure those are not included.<br>
`rails generate rspec:install`

* Database creation/initialization

install; `gem 'mongoid', '~> 8.1.0'`<br>
then `rails generate mongoid:config`<br>
In the config/mongoid.yml file, modify the server_selection_timeout for self hosted mongodb:
```yaml
development:
  clients:
    default:
      database: blog_development
      hosts:
        - localhost:27017
      options:
        server_selection_timeout: 1
```
<br>
Mongodb needs to be running locally for the test/development suite to function. 

[Install MongoDB on macOS](https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/) if you haven't already. <br>
    If installed with Homebrew, then start up the mongodb server with <br>
`brew services start mongodb/brew/mongodb-community` and stop with <br>
`brew services stop mongodb/brew/mongodb-community`<br>
Optionally: use MongoDB Compass to inspect local MongoDBs.

* How to run the test suite

ensure `gem "mongoid-rspec"` (used in-place of Should Matchers on Models) && 
`gem "database_cleaner-mongoid"` has been installed<br>
Either in the `[rails_helper.rb]` or `before :each` in the spec files, add `DatabaseCleaner.clean` to clean the db. <br>
*Run the tests* <br>
`bundle exec rspec` : for all tests<br>
`bunlde exec rspec spec/api/v0` : for api endpoint tests

* Services (job queues, cache servers, search engines, etc.)

This project uses Redis as a caching service.
Start the redis server with `redis-server` <br>
Monitor activity with `redis-cli monitor` <br>
Don't forget to configure the `/environments/*` and specify the `$redis = Redis.new(url: ENV["REDIS_URL"])` <br>
of your local or hosted Redis server. <br>
In your `/spec/rails_helper.rb`: <br>
```ruby
config.before(:each) do
    $redis.flushdb
end
```

## Learning Goals
- Expose an API that aggregates data from multiple external APIs
- Expose an API that requires an authentication token
- Expose an API for CRUD functionality
- Determine completion criteria based on the needs of other developers
- Test both API consumption and exposure, making use of at least one mocking tool (VCR, Webmock, etc).

## API Keys
Keys are stored in the [credentials.yml.enc] file.  You will need to make a new file and store your own API keys there.
- [MapQuest Geocoding API](https://developer.mapquest.com/documentation/geocoding-api/overview/)
  - alias: `mapquest_key`
- [Weather API](https://www.weatherapi.com/)
  - alias: `weahter_key`

## Endpoint Use
### Road Trip Use
- `POST /api/v0/users`
  - create a new user
    - body: `{ "email": "<EMAIL>", "password": "<PASSWORD>", "password_confirmation": "<PASSWORD>" }`
      - get back an `api_key`
- `POST /api/v0/sessions`
  - login with email and password
    - body: `{ "email": "<EMAIL>", "password": "<PASSWORD>" }`
      - get back an `api_key`
- `POST /api/v0/roadtrips`
  - body: `{ "origin": "string", "destination": "string", "api_key": "<API_KEY>" }`
    - get back a road_trip object with travel time and destination weather info