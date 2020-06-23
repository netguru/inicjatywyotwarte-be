# Inicjatywy Otwarte

## Description
🚀 [Have a look](https://inicjatywyotwarte.pl/) 🚀

The application is an aggregator of initiatives useful during COVID-19 times and not only. Guests can propose new initiatives from the website, which will then be reviewed by moderators. A user can also upvote initiatives with 'Pomocne' if it was helpful.

- This aplication is the backend API service for a frontend [React application](https://github.com/netguru/quarantine-helper-fe)
- Its main component is the admin panel for initiative moderators.
- In the first phase the application was serving initiatives via Grape endpoints, then there was decision made to store the whole JSON with all initiatives on S3 bucket. Crono scheduler periodically regenerates this JSON to update upvotes count. Workers are enqueued wnenever admin/reviewer makes change to an initiative in the admin panel. Right now, we're using the endpoint only for upvoting purpose and initiative creation. (The location is validated using GMP Geocoding) 


## Tech 
- Ruby [version](https://github.com/netguru/quarantine-helper-be/blob/master/.ruby-version)
- Rails [version](https://github.com/netguru/quarantine-helper-be/blob/master/Gemfile)
- PostgreSQL 11.4
- Redis

## Code of conduct
- [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md)

## Contributing
How to contribute to inicjatywyotwarte?

- [Contributing guide](CONTRIBUTING.md)

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

## License
- [License](LICENSE)



