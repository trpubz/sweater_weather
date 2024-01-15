# Sweater Weather

You are a back-end developer working on a team that is building an application to plan road trips. This app will allow users to see the current weather as well as the forecasted weather at the destination.

Your team is working in a service-oriented architecture. The front-end will communicate with your back-end through an API. Your job is to expose that API that satisfies the front-end team’s requirements.

* Ruby version 

`3.2.2`

* Configuration

to use `mongoid`<br>
`rails new <NAME> --api --skip-active-record --skip-bundle`

* Database creation/initialization

`rails g mongoid:config`

* How to run the test suite

`bundle exec rspec`:for all tests<br>
`bunlde exec rspec spec/api/v0/forecast_spec.rb`:for api endpoint tests

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Learning Goals
- Expose an API that aggregates data from multiple external APIs
- Expose an API that requires an authentication token
- Expose an API for CRUD functionality
- Determine completion criteria based on the needs of other developers
- Test both API consumption and exposure, making use of at least one mocking tool (VCR, Webmock, etc).

## API Keys
- [MapQuest Geocoding API](https://developer.mapquest.com/documentation/geocoding-api/overview/)
- [Weather API](https://www.weatherapi.com/)

## Endpoint Use
