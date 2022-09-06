source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgres as the database for Active Record
gem 'pg', '~> 0.18.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'newrelic_rpm', '~> 3.16', '>= 3.16.3.323'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
#this is a time picker app
gem 'jquery-timepicker-rails'
# allows you to select a country. Active admin made me install this. this is the link https://github.com/stefanpenner/country_select
gem 'country_select'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# This is for searching
gem 'ransack', '~> 1.7'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'owlcarousel-rails', '~> 1.1.3.3'

# Makes seed data for development
gem 'faker',                '1.4.2'

#this gems are for real time messaging
gem 'private_pub'
gem 'thin'

gem "refile-s3"
gem 'omniauth'
gem 'omniauth-facebook'

# These are the two gems to make the file uploading work.
gem 'refile', require: "refile/rails", git: 'https://github.com/refile/refile.git', branch: 'master'
gem 'refile-mini_magick', github: 'refile/refile-mini_magick'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'active_link_to'
# this is for our admin section
gem 'activeadmin', github: 'gregbell/active_admin'
# this is for logining into our admin section.
gem 'devise'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'font-awesome-rails'

gem 'bootstrap-sass', '~> 3.2.0'

gem 'stripe'

gem 'mail_form'

gem 'simple_form'
# this is so we can have tags for ambassadors
gem 'acts-as-taggable-on', '~> 3.4'

# keeps brads emails password safe from chris so he can not email all the hot girls I know.
gem 'figaro'
# This is the Amazon S3 gem where the ambassadors phtos will be stored.
gem 'aws-sdk'

gem 'puma'

gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'bootstrap-select-rails'
gem 'react-bootstrap-rails'
gem 'twilio-ruby', '~> 4.1.0'

gem 'react-rails', '~> 1.6.0'

gem "rails_best_practices"

#mailing
gem 'nokogiri'
gem 'premailer-rails'

#gem 'roadie', '~> 3.1.1'
# background tasks
gem 'delayed_job_active_record'
gem "daemons"

group :development, :test do
    gem 'pry-rails'
	gem 'foreman'
	gem 'quiet_assets'
	gem 'better_errors'
	gem 'byebug', '~> 4.0.5'
  	gem 'web-console', '~> 2.0'
  	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  	gem 'spring', '~> 1.3.4'
	gem 'binding_of_caller'
	gem "letter_opener"
end


group :production do
	gem 'rails_12factor'
	gem 'font_assets'
end
ruby '2.1.5'
