# frozen_string_literal: true
source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'dotenv-rails'

gem 'pg'
# schema_plus would be nice once it supports rails 5

gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jbuilder'
gem 'bootstrap-sass'

gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin.git'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources.git'
gem 'devise'
gem 'chosen-rails'

gem 'paperclip'
gem 'aws-sdk'

gem 'remotipart'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'spreadsheet'
gem 'roo', '~> 2.7.0'

gem 'hashdiff'

gem 'watir-webdriver'
gem 'selenium-webdriver', '> 3.0.0'
gem 'wombat'
gem 'delocalize'

gem 'net-ssh'

gem 'codeclimate-test-reporter', group: :test, require: nil

group :development, :test do
  gem 'foreman'

  gem 'fakes3'

  gem 'byebug', platform: :mri
  gem 'rubocop'

  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'turnip'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-postgresql'
  gem 'capistrano3-nginx'
  gem 'capistrano3-puma'

  gem 'overcommit'

  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'annotate'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
