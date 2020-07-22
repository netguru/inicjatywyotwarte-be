# Inicjatywy Otwarte

## Description
🚀 [Have a look](https://inicjatywyotwarte.pl/) 🚀

The application is an aggregator of initiatives useful during COVID-19 times and not only. Guests can propose new initiatives from the website, which will then be reviewed by moderators. A user can also upvote initiatives with 'Pomocne' if it was helpful.

- This application is the backend API service for a frontend [React application](https://github.com/netguru/inicjatywyotwarte-fe)
- Its main component is the admin panel for initiative moderators.
- In the first phase the application was serving initiatives via Grape endpoints, then there was decision made to store the whole JSON with all initiatives on S3 bucket. Crono scheduler periodically regenerates this JSON to update upvotes count. Workers are enqueued whenever admin/reviewer makes change to an initiative in the admin panel. Right now, we're using the endpoint only for upvoting purpose and initiative creation. (The location is validated using GMP Geocoding) 


## Tech 
- Ruby [version](https://github.com/netguru/inicjatywyotwarte-be/blob/master/.ruby-version)
- Rails [version](https://github.com/netguru/inicjatywyotwarte-be/blob/master/Gemfile)
- PostgreSQL 11.4
- Redis

We're pushing JSONs to AWS s3 bucket. In development environment we're using `localstack` that emulates AWS services.

Localstack is configured in FE repository, clone it and navigate to it's main directory.

You need to have docker-compose installed, then run:

`docker-compose -f localstack-docker-compose.yml up`

or

`docker-compose -f localstack-docker-compose.yml up -d` to run in background.

If service is running, application should properly push JSONs to faked s3.

You can use localstack with AWS CLI or SDK. You just need to add `--endpoint-url=http://localhost:4572` option.

Example:
`aws --endpoint-url=http://localhost:4572  s3 ls s3://local-bucket/`

## How to contribute to Inicjatywy Otwarte?
We are an open source project and we work in a similar way to other such projects. You can write up an issue, create a pull request and just talk to us about things we could improve. For more information you can have a look at our [Contributing Guide](CONTRIBUTING.md). 

**Note:** if you have noticed any security issue please contact us directly at inicjatywyotwarte@netguru.com.


## Seeds
#### Active Admin accounts:

| email/login                                             | role              | password       |
| ------------------------------------------------------- | ----------------- | -------------- |
| `superadmin@example.com`                                | super_admin       | `password`     |
| `reviewer@example.com`                                  | reviewer          | `password`     |
| `superreviewer@example.com`                             | super_reviewer    | `password`     |

## Routes
`/sidekiq` Sidekiq Web UI

`/crono` Crono scheduler Web UI

`/swagger` or `/` Swagger API docs

`/admin` Active Admin Panel

## Code of conduct
- [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md)

## License
- [License](LICENSE)



