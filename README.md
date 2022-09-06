# Shyft
### Hire reliable event staff

## Project Requirements:
* Ruby 2.1
* Rails 4.2
* Postgres 9.4+
* Node.js v4.6.1 or higher

## Setup for Local builds

1. Run NPM Install to install all the required node modules as needed

2. Install gemfiles

3. Seed the database

* bundle exec rake db:create

* bundle exec rake db:migrate

4. Start Rails Server

5. In a separate Terminal run webpack --progress --colors --watch

6. Sign in as an ambassador generated via the seed file

7. Give ambassador an image and set Unavailability.

8. Sign out.

9. Sign in as an agency.

10. Go to New Event.

11. Fill out details and hit Find Ambassadors

## Deploying to Production
1. Push master to Heroku
2. After successful push, run rake db:migrate
3. If any issues seeing a deployed change, restart the dynos


## How to Deploy to Staging
1. Add staging to your git remote
  * git remote add staging https://git.heroku.com/shyft-staging.git
  * git remote set-url staging https://git.heroku.com/shyft-staging.git
2. Only Develop branch can be pushed to staging
  * git checkout develop
  * git push staging develop:master

