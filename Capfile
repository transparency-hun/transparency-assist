require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/postgresql'
require 'capistrano/nginx'
require 'capistrano/puma'
require 'capistrano/puma/nginx'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
